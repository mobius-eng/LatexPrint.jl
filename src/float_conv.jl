function convert_float(x :: T, precision = 5) where T <: AbstractFloat
    if x <= 0.0001 || x >= 10000
        # Use scientific format
        raw_io = IOBuffer()
        printfmt(raw_io, "{1:.$(precision-1)e}", x)
        # In scientific format but with requested precision
        raw_str = String(take!(raw_io))
    else
        # Use plain format
        extra_digits = 0
        y = x
        while y >= 1.0
            y = y / 10
            extra_digits -= 1
        end
        while y <= 0.1
            y = y * 10
            extra_digits += 1
        end
        raw_io = IOBuffer()
        printfmt(raw_io, "{1:.$(precision+extra_digits)f}", x)
        # In scientific format but with requested precision
        raw_str = String(take!(raw_io))
    end
    started_exponent = false
    res_out = IOBuffer()
    for c in raw_str
        if c == '-' || c == '+'
            print(res_out, c)
        elseif c == 'e' || c == 'f'
            print(res_out, "\\times 10^{")
            started_exponent = true
        elseif c == '.'
            print(res_out, c)
        else
            print(res_out, c)
        end
    end
    # clean up
    if started_exponent
        print(res_out, '}')
    end
    return String(take!(res_out))
end
