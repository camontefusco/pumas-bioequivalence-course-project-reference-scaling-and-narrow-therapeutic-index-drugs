# student_project_2_run_and_save_v4.jl
#
# Student Project 2 — Tasks 1–5 runner (robust across Bioequivalence versions)
# Runs PJ2017_4_3, PJ2017_4_4, CL2009_9_4_1 and saves plain-text output to:
#   student_project_2_outputs.txt
#
# Run:
#   julia student_project_2_run_and_save_v4.jl

using DataFrames
using Dates
using Printf

using Pumas
using Bioequivalence

# ----------------------------
# helpers
# ----------------------------

function save_block(io::IO, title::AbstractString, obj)
    println(io, "\n\n", "="^110)
    println(io, title)
    println(io, "="^110, "\n")
    show(io, MIME"text/plain"(), obj)
    println(io)
end

function try_run(io::IO, title::AbstractString, f::Function)
    try
        result = f()
        save_block(io, title, result)
        return true, result
    catch err
        println(io, "\n\n", "="^110)
        println(io, title, "  [ERROR]")
        println(io, "="^110, "\n")
        showerror(io, err, catch_backtrace())
        println(io)
        return false, nothing
    end
end

has_endpoint(df::AbstractDataFrame, endpoint::Symbol) = (String(endpoint) in names(df))

# ----------------------------
# dataset loading
# ----------------------------
data_pj43 = nothing
data_pj44 = nothing
data_cl   = nothing

try
    if @isdefined(dataset)
        data_pj43 = dataset(joinpath("bioequivalence", "RTTR_TRRT", "PJ2017_4_3"))
        data_pj44 = dataset(joinpath("bioequivalence", "RTRT_TRTR", "PJ2017_4_4"))
        data_cl   = dataset(joinpath("bioequivalence", "RTTR_TRRT", "CL2009_9_4_1"))
    else
        try
            @eval using PharmaDatasets
        catch
        end
        if @isdefined(dataset)
            data_pj43 = dataset(joinpath("bioequivalence", "RTTR_TRRT", "PJ2017_4_3"))
            data_pj44 = dataset(joinpath("bioequivalence", "RTRT_TRTR", "PJ2017_4_4"))
            data_cl   = dataset(joinpath("bioequivalence", "RTTR_TRRT", "CL2009_9_4_1"))
        end
    end
catch
end

# ----------------------------
# Task 1 extraction from pumas_be output text
# ----------------------------

"""
Parse CVr, sigmar, CVt, sigmat from the pumas_be plain-text table.
Returns NamedTuple with fields (CVr, sigmar, CVt, sigmat) or throws.
"""
function parse_variability_from_show(be_result)::NamedTuple
    txt = sprint(show, MIME"text/plain"(), be_result)

    # Matches lines like:
    # "CVᵣ (%) | σ̂ᵣ                   35.4 | 0.3436"
    # "CVₜ (%) | σ̂ₜ                   27.87 | 0.2735"
    #
    # We accept both unicode r/t subscripts and plain r/t variants.
    re_r = r"CV[ᵣr]\s*\(%\)\s*\|\s*σ̂[ᵣr]\s+([0-9]+(?:\.[0-9]+)?)\s*\|\s*([0-9]+(?:\.[0-9]+)?)"
    re_t = r"CV[ₜt]\s*\(%\)\s*\|\s*σ̂[ₜt]\s+([0-9]+(?:\.[0-9]+)?)\s*\|\s*([0-9]+(?:\.[0-9]+)?)"

    mr = match(re_r, txt)
    mt = match(re_t, txt)

    if mr === nothing
        error("Could not parse CVr/sigmar from output.")
    end
    if mt === nothing
        error("Could not parse CVt/sigmat from output.")
    end

    CVr    = parse(Float64, mr.captures[1])
    sigmar = parse(Float64, mr.captures[2])
    CVt    = parse(Float64, mt.captures[1])
    sigmat = parse(Float64, mt.captures[2])

    return (CVr=CVr, sigmar=sigmar, CVt=CVt, sigmat=sigmat)
end

"""
Task 1 rule summary (course-style):
- HVD: CVr >= 30%
- OK_for_RS: HVD && CVr <= 50% (cap)
Uses pumas_be result as the source of variability.
"""
function task1_from_be(be_result; endpoint::Symbol, cv_max_percent::Float64=50.0)
    v = parse_variability_from_show(be_result)
    HVD = v.CVr >= 30.0
    OK_for_RS = HVD && (v.CVr <= cv_max_percent)
    return (
        endpoint = endpoint,
        CVr = v.CVr,
        sigmar = v.sigmar,
        CVt = v.CVt,
        sigmat = v.sigmat,
        HVD = HVD,
        OK_for_RS = OK_for_RS,
        rule = "HVD: CVr≥30%; OK_for_RS: CVr≤$(cv_max_percent)% (cap)"
    )
end

# ----------------------------
# Run tasks for one dataset
# ----------------------------

function run_all_tasks_for_dataset(io::IO, dataset_name::String, df::DataFrame)
    save_block(io, "DATASET: $dataset_name — column names", names(df))

    # Task 2 first (Standard ABE) so we can reliably extract CVs for Task 1
    ok_auc, be_auc = try_run(io, "Task 2 — Standard ABE — $dataset_name — endpoint=:AUC",
        () -> pumas_be(df, StandardBioequivalenceCriterion; endpoint=:AUC)
    )

    if ok_auc
        try_run(io, "Task 1 — CVr/CVt + HVD + OK_for_RS (derived from Task 2 output) — $dataset_name — endpoint=:AUC",
            () -> task1_from_be(be_auc; endpoint=:AUC, cv_max_percent=50.0)
        )
    end

    if has_endpoint(df, :Cmax)
        ok_cmax, be_cmax = try_run(io, "Task 2 — Standard ABE — $dataset_name — endpoint=:Cmax",
            () -> pumas_be(df, StandardBioequivalenceCriterion; endpoint=:Cmax)
        )
        if ok_cmax
            try_run(io, "Task 1 — CVr/CVt + HVD + OK_for_RS (derived from Task 2 output) — $dataset_name — endpoint=:Cmax",
                () -> task1_from_be(be_cmax; endpoint=:Cmax, cv_max_percent=50.0)
            )
        end
    else
        save_block(io, "Task 2 — $dataset_name — endpoint=:Cmax (SKIPPED)", "No :Cmax column in this dataset.")
        save_block(io, "Task 1 — $dataset_name — endpoint=:Cmax (SKIPPED)", "No :Cmax column in this dataset.")
    end

    # Task 3 — FDA Highly Variable (RSABE) — Cmax only
    if has_endpoint(df, :Cmax)
        try_run(io, "Task 3 — FDA Highly Variable (RSABE) — $dataset_name — endpoint=:Cmax",
            () -> pumas_be(df, FDA_HighlyVariable; endpoint=:Cmax)
        )
    else
        save_block(io, "Task 3 — $dataset_name (SKIPPED)", "No :Cmax column in this dataset.")
    end

    # Task 4 — EMA NTI
    try_run(io, "Task 4 — EMA Narrow Therapeutic Index — $dataset_name — endpoint=:AUC",
        () -> pumas_be(df, EMA_NarrowTherapeuticIndex; endpoint=:AUC)
    )
    if has_endpoint(df, :Cmax)
        try_run(io, "Task 4 — EMA Narrow Therapeutic Index — $dataset_name — endpoint=:Cmax",
            () -> pumas_be(df, EMA_NarrowTherapeuticIndex; endpoint=:Cmax)
        )
    else
        save_block(io, "Task 4 — $dataset_name — endpoint=:Cmax (SKIPPED)", "No :Cmax column in this dataset.")
    end

    # Task 5 — FDA NTI
    try_run(io, "Task 5 — FDA Narrow Therapeutic Index (RSABE-NTI) — $dataset_name — endpoint=:AUC",
        () -> pumas_be(df, FDA_NarrowTherapeuticIndex; endpoint=:AUC)
    )
    if has_endpoint(df, :Cmax)
        try_run(io, "Task 5 — FDA Narrow Therapeutic Index (RSABE-NTI) — $dataset_name — endpoint=:Cmax",
            () -> pumas_be(df, FDA_NarrowTherapeuticIndex; endpoint=:Cmax)
        )
    else
        save_block(io, "Task 5 — $dataset_name — endpoint=:Cmax (SKIPPED)", "No :Cmax column in this dataset.")
    end
end

# ----------------------------
# MAIN
# ----------------------------

open("student_project_2_outputs.txt", "w") do io
    println(io, "Student Project 2 — Tasks 1–5 outputs")
    println(io, "Generated by: student_project_2_run_and_save_v4.jl")
    println(io, "Timestamp: ", Dates.now())
    println(io, "\n")

    if any(x -> x === nothing, (data_pj43, data_pj44, data_cl))
        println(io, "ERROR: One or more datasets were not loaded.\n")
        println(io, "Make sure PharmaDatasets is available, or load datasets manually and assign:")
        println(io, "  data_pj43 = <DataFrame>  # PJ2017_4_3")
        println(io, "  data_pj44 = <DataFrame>  # PJ2017_4_4")
        println(io, "  data_cl   = <DataFrame>  # CL2009_9_4_1")
        return
    end

    run_all_tasks_for_dataset(io, "PJ2017_4_3", data_pj43)
    run_all_tasks_for_dataset(io, "PJ2017_4_4", data_pj44)
    run_all_tasks_for_dataset(io, "CL2009_9_4_1", data_cl)

    println(io, "\n\nDONE. Outputs saved above.\n")
end

println("✅ Saved: student_project_2_outputs.txt")