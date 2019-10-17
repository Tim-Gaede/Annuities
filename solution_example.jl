#-------------------------------------------------------------------------------
function annuityAPR(ratio::Float64, numPayouts::Int)
    if ratio < 1.0
        msg = "The money multiplication (ratio) must be at least one."
        throw(DomainError(msg))
    end

    if numPayouts < 2
        throw(DomainError("The number of payouts must be at least 2."))
    end


    # Use Newton-Raphson method to approach the correct APR

    # First APR guess
    APR_prev = 0.0 # lower limit
    ratio_prev = equivalent(APR_prev, numPayouts)
    error_prev = ratio_prev - ratio

    # Second APR guess
    APR_curr = 100(ratio-1.0) # upper limit
    ratio_curr = annuityRatio(APR_curr, numPayouts)
    error_curr = ratio_curr - ratio

    # Repeatedly use the most recent two APR guesses to
    # estimate a new APR guess until this newest APR guess
    # yields an infinitesimal absolute error.
    ε = 10^-8
    while abs(error_curr) > ε
        Δerror = error_curr - error_prev
        ΔAPR  = APR_curr - APR_prev

        slope = Δerror / ΔAPR


        APR_prev   = APR_curr
        ratio_prev = ratio_curr
        error_prev = error_curr

        APR_curr   -= error_curr / slope
        ratio_curr  = annuityRatio(APR_curr, numPayouts)
        error_curr  = ratio_curr - ratio
    end



    APR_curr # returned
end
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# equivalent single payout
function annuityRatio(APR::Float64, numPayouts::Int)
    if APR < 0.0
        throw(DomainError("Annual Percentage Rate (APR) cannot be negative."))
    end

    if numPayouts < 2
        throw(DomainError("The number of payouts must be at least 2."))
    end

    res = 0.0
    payout = 1 / numPayouts
    multiplier = 1.0 + APR/100
    for t = 0 : numPayouts - 1
        res += payout * multiplier^t
    end


    res # returned
end
#-------------------------------------------------------------------------------
