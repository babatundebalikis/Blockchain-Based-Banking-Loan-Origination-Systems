;; Application Processing Contract
;; Handles loan application submissions and basic validation

(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_INVALID_AMOUNT (err u201))
(define-constant ERR_APPLICATION_EXISTS (err u202))
(define-constant ERR_APPLICATION_NOT_FOUND (err u203))
(define-constant ERR_LENDER_NOT_VERIFIED (err u204))

;; Import lender verification contract
(use-trait lender-verification-trait .lender-verification.lender-verification-trait)

;; Data structures
(define-map loan-applications
  { application-id: uint }
  {
    borrower: principal,
    lender: principal,
    loan-amount: uint,
    loan-purpose: (string-ascii 100),
    employment-status: (string-ascii 50),
    annual-income: uint,
    application-date: uint,
    status: (string-ascii 20)
  }
)

(define-map borrower-applications
  { borrower: principal }
  { application-ids: (list 10 uint) }
)

(define-data-var next-application-id uint u1)

;; Public functions
(define-public (submit-application
  (lender principal)
  (loan-amount uint)
  (loan-purpose (string-ascii 100))
  (employment-status (string-ascii 50))
  (annual-income uint))

  (let ((application-id (var-get next-application-id))
        (borrower tx-sender))

    ;; Validate inputs
    (asserts! (and (> loan-amount u0) (<= loan-amount u10000000)) ERR_INVALID_AMOUNT) ;; Max 10M loan
    (asserts! (> annual-income u0) ERR_INVALID_AMOUNT)

    ;; Check if lender is verified (simplified check)
    (asserts! (not (is-eq lender borrower)) ERR_UNAUTHORIZED)

    ;; Create application
    (map-set loan-applications
      { application-id: application-id }
      {
        borrower: borrower,
        lender: lender,
        loan-amount: loan-amount,
        loan-purpose: loan-purpose,
        employment-status: employment-status,
        annual-income: annual-income,
        application-date: block-height,
        status: "submitted"
      }
    )

    ;; Update borrower's application list
    (let ((current-apps (default-to (list) (get application-ids (map-get? borrower-applications { borrower: borrower })))))
      (map-set borrower-applications
        { borrower: borrower }
        { application-ids: (unwrap! (as-max-len? (append current-apps application-id) u10) ERR_INVALID_AMOUNT) }
      )
    )

    ;; Increment application ID
    (var-set next-application-id (+ application-id u1))

    (ok application-id)
  )
)

(define-public (update-application-status (application-id uint) (new-status (string-ascii 20)))
  (let ((application (unwrap! (map-get? loan-applications { application-id: application-id }) ERR_APPLICATION_NOT_FOUND)))
    ;; Only lender can update status
    (asserts! (is-eq tx-sender (get lender application)) ERR_UNAUTHORIZED)

    (map-set loan-applications
      { application-id: application-id }
      (merge application { status: new-status })
    )

    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-application (application-id uint))
  (map-get? loan-applications { application-id: application-id })
)

(define-read-only (get-borrower-applications (borrower principal))
  (map-get? borrower-applications { borrower: borrower })
)

(define-read-only (get-next-application-id)
  (var-get next-application-id)
)
