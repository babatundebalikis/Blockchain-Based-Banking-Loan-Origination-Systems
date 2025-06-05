;; Credit Assessment Contract
;; Evaluates borrower creditworthiness

(define-constant ERR_UNAUTHORIZED (err u300))
(define-constant ERR_INVALID_SCORE (err u301))
(define-constant ERR_ASSESSMENT_EXISTS (err u302))
(define-constant ERR_ASSESSMENT_NOT_FOUND (err u303))

;; Data structures
(define-map credit-assessments
  { borrower: principal }
  {
    credit-score: uint,
    debt-to-income-ratio: uint,
    payment-history-score: uint,
    employment-stability: uint,
    assessment-date: uint,
    risk-level: (string-ascii 20)
  }
)

(define-map authorized-assessors
  { assessor: principal }
  { is-authorized: bool }
)

;; Initialize contract owner as authorized assessor
(map-set authorized-assessors { assessor: tx-sender } { is-authorized: true })

;; Public functions
(define-public (authorize-assessor (assessor principal))
  (begin
    (asserts! (get is-authorized (default-to { is-authorized: false } (map-get? authorized-assessors { assessor: tx-sender }))) ERR_UNAUTHORIZED)
    (map-set authorized-assessors { assessor: assessor } { is-authorized: true })
    (ok true)
  )
)

(define-public (create-credit-assessment
  (borrower principal)
  (credit-score uint)
  (debt-to-income-ratio uint)
  (payment-history-score uint)
  (employment-stability uint))

  (let ((risk-level (calculate-risk-level credit-score debt-to-income-ratio payment-history-score employment-stability)))
    ;; Only authorized assessors can create assessments
    (asserts! (get is-authorized (default-to { is-authorized: false } (map-get? authorized-assessors { assessor: tx-sender }))) ERR_UNAUTHORIZED)

    ;; Validate scores
    (asserts! (and (<= credit-score u850) (>= credit-score u300)) ERR_INVALID_SCORE)
    (asserts! (<= debt-to-income-ratio u100) ERR_INVALID_SCORE)
    (asserts! (<= payment-history-score u100) ERR_INVALID_SCORE)
    (asserts! (<= employment-stability u100) ERR_INVALID_SCORE)

    (map-set credit-assessments
      { borrower: borrower }
      {
        credit-score: credit-score,
        debt-to-income-ratio: debt-to-income-ratio,
        payment-history-score: payment-history-score,
        employment-stability: employment-stability,
        assessment-date: block-height,
        risk-level: risk-level
      }
    )

    (ok true)
  )
)

(define-public (update-credit-score (borrower principal) (new-credit-score uint))
  (let ((assessment (unwrap! (map-get? credit-assessments { borrower: borrower }) ERR_ASSESSMENT_NOT_FOUND)))
    (asserts! (get is-authorized (default-to { is-authorized: false } (map-get? authorized-assessors { assessor: tx-sender }))) ERR_UNAUTHORIZED)
    (asserts! (and (<= new-credit-score u850) (>= new-credit-score u300)) ERR_INVALID_SCORE)

    (let ((updated-assessment (merge assessment {
      credit-score: new-credit-score,
      assessment-date: block-height,
      risk-level: (calculate-risk-level
        new-credit-score
        (get debt-to-income-ratio assessment)
        (get payment-history-score assessment)
        (get employment-stability assessment))
    })))
      (map-set credit-assessments { borrower: borrower } updated-assessment)
      (ok true)
    )
  )
)

;; Private functions
(define-private (calculate-risk-level (credit-score uint) (debt-ratio uint) (payment-score uint) (employment-score uint))
  (let ((total-score (+ credit-score payment-score employment-score)))
    (if (and (>= credit-score u750) (<= debt-ratio u30) (>= payment-score u80))
      "low"
      (if (and (>= credit-score u650) (<= debt-ratio u50) (>= payment-score u60))
        "medium"
        "high"
      )
    )
  )
)

;; Read-only functions
(define-read-only (get-credit-assessment (borrower principal))
  (map-get? credit-assessments { borrower: borrower })
)

(define-read-only (is-authorized-assessor (assessor principal))
  (get is-authorized (default-to { is-authorized: false } (map-get? authorized-assessors { assessor: assessor })))
)

(define-read-only (get-risk-level (borrower principal))
  (match (map-get? credit-assessments { borrower: borrower })
    assessment (some (get risk-level assessment))
    none
  )
)
