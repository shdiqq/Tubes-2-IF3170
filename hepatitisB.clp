; Program CLIPS untuk prediksi terkait kondisi terkait dengan hepatitis B.
; Made by:
; Shadiq Harwiz          13520038
; Muhammad Rakha Athaya  13520108

(deffacts starting
    (phase-HBsAg) ; Pertanyaan pertama
)

(defrule tanya-HBsAg
    (phase-HBsAg)
=>
    (printout t "HBsAg? ")
    (assert(is-HBsAg (read)))
)

(defrule catch-HBsAg
    ; Catch untuk handling invalid user input
    ?phase <- (phase-HBsAg)
    ?input <- (is-HBsAg ?x&~positive&~negative)
=> 
    (retract ?phase ?input)
    (assert (phase-HBsAg))
    (printout t "Please answer with positive or negative." crlf)  
)

(defrule eval-HBsAg
    ?phase <- (phase-HBsAg)
    (is-HBsAg ?x&positive | negative)
=>
    (retract ?phase)
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

(defrule catch-anti-HBc
    ?phase <- (anti-HBc)
    ?input <- (is-anti-HBc ?x&~positive&~negative)
=> 
    (retract ?phase ?input)
    (assert (anti-HBc))
    (printout t "Please answer with positive or negative." crlf)  
)

(defrule tanya-anti-HBs
    (anti-HBs)
=>
    (printout t "anti-HBs? ")
    (assert (is-anti-HBs (read)))
)

(defrule catch-anti-HBs
    ?phase <- (anti-HBs)
    ?input <- (is-anti-HBs ?x&~positive&~negative)
=> 
    (retract ?phase ?input)
    (assert (anti-HBs))
    (printout t "Please answer with positive or negative." crlf)  
)

; Branch kiri

(defrule tanya-anti-HDV
    (anti-HDV)
=>
    (printout t "anti-HDV? ")
    (assert(is-anti-HDV (read)))
)

(defrule catch-anti-HDV
    ?phase <- (anti-HDV)
    ?input <- (is-anti-HDV ?x&~positive&~negative)
=> 
    (retract ?phase ?input)
    (assert (anti-HDV))
    (printout t "Please answer with positive or negative." crlf)  
)

(defrule eval-anti-HDV
    (is-anti-HDV ?x&positive | negative)
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
    (is-anti-HBc ?x&positive | negative)
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
    (is-anti-HBs ?x&positive | negative)
    (branch-kiri)
=>
    (if (eq ?x positive)
        then
        (printout t crlf "Hasil Prediksi = Uncertain Configuration" crlf)
        (halt)
        else
        (assert (IgM-anti-HBc))
    )
)

(defrule tanya-IgM-anti-HBc
    (IgM-anti-HBc)
=>
    (printout t "IgM-anti-HBc? ")
    (assert(is-IgM-anti-HBc (read)))
)

(defrule catch-IgM-anti-HBc
    ?phase <- (IgM-anti-HBc)
    ?input <- (is-IgM-anti-HBc ?x&~positive&~negative)
=> 
    (retract ?phase ?input)
    (assert (IgM-anti-HBc))
    (printout t "Please answer with positive or negative." crlf)  
)

(defrule eval-IgM-anti-HBc
    (is-IgM-anti-HBc ?x&positive | negative)
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
    (is-anti-HBs ?x&positive | negative)
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
    (is-anti-HBc ?x&positive | negative)
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
    (is-anti-HBc ?x&positive | negative)
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