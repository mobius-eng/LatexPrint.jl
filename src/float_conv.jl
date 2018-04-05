function convert_float(x :: T, precision = 5) where T <: AbstractFloat
    raw_str = string(x)
    precision_count = 0
    started_significant = false
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
        elseif isdigit(c) && started_exponent
            print(res_out, c)
        else
            if c == '0' && (!started_significant)
                print(res_out, c)
            elseif c != '0' && (!started_significant)
                started_significant = true
                precision_count = 1
                print(res_out, c)
            elseif precision_count < precision
                precision_count += 1
                print(res_out, c)
            else
                continue
            end
        end
    end
    # clean up
    if started_exponent
        print(res_out, '}')
    end
    return String(take!(res_out))
end
