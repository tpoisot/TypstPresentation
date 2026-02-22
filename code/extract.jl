function extract_code_chunks(file; opening="# CHUNK", closing="# END")

    loc = readlines(file)

    io = nothing
    writing = false
    pointer = 0

    saved_chunks = []

    for line in loc
        if startswith(line, opening)
            writing = false
            close(io)
        end
        if writing
            println(io, line)
        end
        if startswith(line, closing)
            @info line
            m = match(r"# CHUNK - (.+)", line)
            pointer += 1
            filename = joinpath("chunks", m[1] * ".jl")
            io = open(filename, "w")
            writing = true
            push!(saved_chunks, filename)
        end
    end
    return saved_chunks
end