;; An on-chain counter that stores a count for each individual

;; Define constant for maximum count value
(define-constant MAX-COUNT u100)

;; Define a map data structure
(define-map counters principal uint)

;; define a variable to track total number
(define-data-var total-ops uint u0)

;;function to retrieve the count for a given individual
(define-read-only (get-count (who principal)) 
  (default-to u0 (map-get? counters who))
)

;; function to get total ops performed
(define-read-only (get-total-operations)
  (var-get total-ops)
)

;;private function to update total operations counter
(define-private (update-total-ops) 
  (var-set total-ops (+ (var-get total-ops) u1))
)

;;function to increment the count for the caller 
(define-public (count-up)
  (let ((current-count (get-count tx-sender))) 
    (asserts! (< current-count MAX-COUNT) (err u1))
    (update-total-ops)
    (ok (map-set counters tx-sender (+ current-count u1)))
  )
)

;; function to decrement the count for the caller
(define-public (count-down)
  (let ((current-count (get-count tx-sender)))
    (asserts! (> current-count u0) (err u2))
    (update-total-ops)
    (ok (map-set counters tx-sender (- current-count u1)))
  )
)

;; function to reset zero
(define-public (reset-count)
  (begin 
    (update-total-ops)
    (ok (map-set counters tx-sender u0))
  )
)


