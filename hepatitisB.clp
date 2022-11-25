(defrule tanya-HBsAg
=>
    (printout t "HBsAg? ")
    (assert(is-HBsAg (read)))
)

(defrule eval-HBsAg
    (is-HBsAg ?x)
=>
    (if (eq ?x positive)
        then
        (assert (anti-HDV))
        else
        (assert (anti-HBs))
        (assert (branch-kanan))
    )
)

; Untuk duplikat : anti-HBs, anti-HBc
(defrule tanya-anti-HBc
    (anti-HBc)
=>
    (printout t "anti-HBc? ")
    (assert (is-anti-HBc (read)))
)

(defrule tanya-anti-HBs
    (anti-HBs)
=>
    (printout t "anti-HBs? ")
    (assert (is-anti-HBs (read)))
)

; Branch kiri

(defrule tanya-anti-HDV
    (anti-HDV)
=>
    (printout t "anti-HDV? ")
    (assert(is-anti-HDV (read)))
)

(defrule eval-anti-HDV
    (is-anti-HDV ?x)
=>
    (if (eq ?x negative)
        then
        (assert (anti-HBc))
        (assert (branch-kiri))
        else
        (printout t crlf "Hasil Prediksi = Hepatitis B+D" crlf)
        (halt)
    )
)

(defrule eval-anti-HBc-kiri
    (is-anti-HBc ?x)
    (branch-kiri)
=>
    (if (eq ?x positive)
        then
        (assert (anti-HBs))
        (assert (branch-kiri))
        else
        (printout t crlf "Hasil Prediksi = Uncertain Configuration" crlf)
        (halt)
    )
)

(defrule eval-anti-HBs-kiri
    (is-anti-HBs ?x)
    (branch-kiri)
=>
    (if (eq ?x positive)
        then
        (printout t crlf "Hasil Prediksi = Uncertain Configuration" crlf)
        (halt)
        else
        (assert (IgM-anti-HBs))
    )
)

(defrule tanya-IgM-anti-HBs
    (IgM-anti-HBs)
=>
    (printout t "IgM-anti-HBs? ")
    (assert(is-IgM-anti-HBs (read)))
)

(defrule eval-IgM-anti-HBs
    (is-IgM-anti-HBs ?x)
=>
    (if (eq ?x positive)
        then
        (printout t crlf "Hasil Prediksi = Acute Infection" crlf)
        (halt)
        else
        (printout t crlf "Hasil Prediksi = Chronic Infection" crlf)
        (halt)
    )
)

; Branch kanan

(defrule eval-anti-HBs-kanan
    (is-anti-HBs ?x)
    (branch-kanan)
=>
    (if (eq ?x positive)
        then
        (assert (anti-HBc))
        (assert (branch-kanan-kiri))
        else
        (assert (anti-HBc))
        (assert (branch-kanan-kanan))
    )
)

(defrule eval-anti-HBc-kanan-kiri
    (is-anti-HBc ?x)
    (branch-kanan-kiri)
=>
    (if (eq ?x positive)
        then
        (printout t crlf "Hasil Prediksi = Cured" crlf)
        (halt)  
        else
        (printout t crlf "Hasil Prediksi = Vaccinated" crlf)
        (halt)
    )
)

(defrule eval-anti-HBc-kanan-kanan
    (is-anti-HBc ?x)
    (branch-kanan-kanan)
=>
    (if (eq ?x positive)
        then
        (printout t crlf "Hasil Prediksi = Unclear (possible resolved)" crlf)
        (halt)
        else
        (printout t crlf "Hasil Prediksi = Healthy not vaccinated or suspicious" crlf)
        (halt)  
    )
)