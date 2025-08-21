;; title: MRDistro
;; version: 1.0.0
;; summary: Decentralized Music Royalty Distribution System

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_SONG_NOT_FOUND (err u101))
(define-constant ERR_INVALID_PERCENTAGE (err u102))
(define-constant ERR_SONG_ALREADY_EXISTS (err u103))
(define-constant ERR_INSUFFICIENT_BALANCE (err u104))
(define-constant ERR_INVALID_RECIPIENT (err u105))
(define-constant ERR_NO_EARNINGS (err u106))
(define-constant ERR_INVALID_AMOUNT (err u107))

(define-data-var total-songs uint u0)
(define-data-var total-royalties-distributed uint u0)

(define-map songs 
  { song-id: uint }
  {
    title: (string-ascii 100),
    artist: principal,
    total-earnings: uint,
    created-at: uint,
    is-active: bool
  }
)

(define-map song-royalty-splits
  { song-id: uint, recipient: principal }
  { percentage: uint, total-earned: uint }
)

(define-map user-balances
  { user: principal }
  { total-balance: uint, total-withdrawn: uint }
)

(define-map song-contributors
  { song-id: uint }
  { contributors: (list 20 principal) }
)

(define-private (is-song-owner (song-id uint) (user principal))
  (match (map-get? songs { song-id: song-id })
    song-data (is-eq (get artist song-data) user)
    false
  )
)

(define-private (validate-percentage-sum (song-id uint) (contributors (list 20 principal)))
  (let ((total-percentage (fold calculate-total-percentage contributors u0)))
    (is-eq total-percentage u100)
  )
)

(define-private (calculate-total-percentage (contributor principal) (current-total uint))
  (match (map-get? song-royalty-splits { song-id: (var-get total-songs), recipient: contributor })
    split-data (+ current-total (get percentage split-data))
    current-total
  )
)

(define-private (distribute-to-contributor (contributor principal) (amount uint))
  (let 
    (
      (current-balance (default-to { total-balance: u0, total-withdrawn: u0 } 
                        (map-get? user-balances { user: contributor })))
      (new-balance (+ (get total-balance current-balance) amount))
    )
    (map-set user-balances 
      { user: contributor }
      { total-balance: new-balance, total-withdrawn: (get total-withdrawn current-balance) }
    )
  )
)

(define-private (calculate-royalty-share (percentage uint) (total-amount uint))
  (/ (* percentage total-amount) u100)
)

(define-public (register-song (title (string-ascii 100)) 
                              (contributors (list 20 principal))
                              (percentages (list 20 uint)))
  (let 
    (
      (song-id (+ (var-get total-songs) u1))
      (total-percentage (fold + percentages u0))
    )
    (asserts! (is-eq total-percentage u100) ERR_INVALID_PERCENTAGE)
    (asserts! (is-eq (len contributors) (len percentages)) ERR_INVALID_PERCENTAGE)
    (asserts! (<= (len contributors) u20) ERR_INVALID_PERCENTAGE)
    
    (map-set songs
      { song-id: song-id }
      {
        title: title,
        artist: tx-sender,
        total-earnings: u0,
        created-at: stacks-block-height,
        is-active: true
      }
    )
    
    (map-set song-contributors
      { song-id: song-id }
      { contributors: contributors }
    )
    
    (setup-all-splits song-id contributors percentages)
    
    (var-set total-songs song-id)
    (ok song-id)
  )
)

(define-private (setup-all-splits (song-id uint) (contributors (list 20 principal)) (percentages (list 20 uint)))
  (and
    (setup-split-if-exists song-id (element-at contributors u0) (element-at percentages u0))
    (setup-split-if-exists song-id (element-at contributors u1) (element-at percentages u1))
    (setup-split-if-exists song-id (element-at contributors u2) (element-at percentages u2))
    (setup-split-if-exists song-id (element-at contributors u3) (element-at percentages u3))
    (setup-split-if-exists song-id (element-at contributors u4) (element-at percentages u4))
    (setup-split-if-exists song-id (element-at contributors u5) (element-at percentages u5))
    (setup-split-if-exists song-id (element-at contributors u6) (element-at percentages u6))
    (setup-split-if-exists song-id (element-at contributors u7) (element-at percentages u7))
    (setup-split-if-exists song-id (element-at contributors u8) (element-at percentages u8))
    (setup-split-if-exists song-id (element-at contributors u9) (element-at percentages u9))
    (setup-split-if-exists song-id (element-at contributors u10) (element-at percentages u10))
    (setup-split-if-exists song-id (element-at contributors u11) (element-at percentages u11))
    (setup-split-if-exists song-id (element-at contributors u12) (element-at percentages u12))
    (setup-split-if-exists song-id (element-at contributors u13) (element-at percentages u13))
    (setup-split-if-exists song-id (element-at contributors u14) (element-at percentages u14))
    (setup-split-if-exists song-id (element-at contributors u15) (element-at percentages u15))
    (setup-split-if-exists song-id (element-at contributors u16) (element-at percentages u16))
    (setup-split-if-exists song-id (element-at contributors u17) (element-at percentages u17))
    (setup-split-if-exists song-id (element-at contributors u18) (element-at percentages u18))
    (setup-split-if-exists song-id (element-at contributors u19) (element-at percentages u19))
  )
)

(define-private (setup-split-if-exists (song-id uint) (contributor (optional principal)) (percentage (optional uint)))
  (match contributor
    contrib (match percentage
              percent (begin
                (map-set song-royalty-splits
                  { song-id: song-id, recipient: contrib }
                  { percentage: percent, total-earned: u0 }
                )
                true)
              true)
    true)
)

(define-public (distribute-royalties (song-id uint) (amount uint))
  (let 
    (
      (song-data (unwrap! (map-get? songs { song-id: song-id }) ERR_SONG_NOT_FOUND))
      (contributors-data (unwrap! (map-get? song-contributors { song-id: song-id }) ERR_SONG_NOT_FOUND))
      (contributors (get contributors contributors-data))
    )
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (asserts! (get is-active song-data) ERR_SONG_NOT_FOUND)
    
    (distribute-to-all-contributors song-id contributors amount)
    
    (map-set songs
      { song-id: song-id }
      (merge song-data { total-earnings: (+ (get total-earnings song-data) amount) })
    )
    
    (var-set total-royalties-distributed (+ (var-get total-royalties-distributed) amount))
    (ok true)
  )
)

(define-private (distribute-to-all-contributors (song-id uint) (contributors (list 20 principal)) (amount uint))
  (and
    (distribute-if-contributor song-id (element-at contributors u0) amount)
    (distribute-if-contributor song-id (element-at contributors u1) amount)
    (distribute-if-contributor song-id (element-at contributors u2) amount)
    (distribute-if-contributor song-id (element-at contributors u3) amount)
    (distribute-if-contributor song-id (element-at contributors u4) amount)
    (distribute-if-contributor song-id (element-at contributors u5) amount)
    (distribute-if-contributor song-id (element-at contributors u6) amount)
    (distribute-if-contributor song-id (element-at contributors u7) amount)
    (distribute-if-contributor song-id (element-at contributors u8) amount)
    (distribute-if-contributor song-id (element-at contributors u9) amount)
    (distribute-if-contributor song-id (element-at contributors u10) amount)
    (distribute-if-contributor song-id (element-at contributors u11) amount)
    (distribute-if-contributor song-id (element-at contributors u12) amount)
    (distribute-if-contributor song-id (element-at contributors u13) amount)
    (distribute-if-contributor song-id (element-at contributors u14) amount)
    (distribute-if-contributor song-id (element-at contributors u15) amount)
    (distribute-if-contributor song-id (element-at contributors u16) amount)
    (distribute-if-contributor song-id (element-at contributors u17) amount)
    (distribute-if-contributor song-id (element-at contributors u18) amount)
    (distribute-if-contributor song-id (element-at contributors u19) amount)
  )
)

(define-private (distribute-if-contributor (song-id uint) (contributor (optional principal)) (amount uint))
  (match contributor
    contrib (match (map-get? song-royalty-splits { song-id: song-id, recipient: contrib })
              split-data 
              (let 
                (
                  (royalty-amount (calculate-royalty-share (get percentage split-data) amount))
                  (new-total-earned (+ (get total-earned split-data) royalty-amount))
                )
                (map-set song-royalty-splits
                  { song-id: song-id, recipient: contrib }
                  { percentage: (get percentage split-data), total-earned: new-total-earned }
                )
                (distribute-to-contributor contrib royalty-amount)
                true
              )
              true)
    true)
)

(define-public (withdraw-earnings)
  (let 
    (
      (user-balance (unwrap! (map-get? user-balances { user: tx-sender }) ERR_NO_EARNINGS))
      (available-balance (get total-balance user-balance))
    )
    (asserts! (> available-balance u0) ERR_NO_EARNINGS)
    
    (try! (stx-transfer? available-balance (as-contract tx-sender) tx-sender))
    
    (map-set user-balances
      { user: tx-sender }
      { 
        total-balance: u0, 
        total-withdrawn: (+ (get total-withdrawn user-balance) available-balance) 
      }
    )
    
    (ok available-balance)
  )
)

(define-public (deactivate-song (song-id uint))
  (let ((song-data (unwrap! (map-get? songs { song-id: song-id }) ERR_SONG_NOT_FOUND)))
    (asserts! (is-song-owner song-id tx-sender) ERR_UNAUTHORIZED)
    
    (map-set songs
      { song-id: song-id }
      (merge song-data { is-active: false })
    )
    (ok true)
  )
)

(define-public (activate-song (song-id uint))
  (let ((song-data (unwrap! (map-get? songs { song-id: song-id }) ERR_SONG_NOT_FOUND)))
    (asserts! (is-song-owner song-id tx-sender) ERR_UNAUTHORIZED)
    
    (map-set songs
      { song-id: song-id }
      (merge song-data { is-active: true })
    )
    (ok true)
  )
)

(define-read-only (get-song-info (song-id uint))
  (map-get? songs { song-id: song-id })
)

(define-read-only (get-song-royalty-split (song-id uint) (recipient principal))
  (map-get? song-royalty-splits { song-id: song-id, recipient: recipient })
)

(define-read-only (get-user-balance (user principal))
  (map-get? user-balances { user: user })
)

(define-read-only (get-song-contributors (song-id uint))
  (map-get? song-contributors { song-id: song-id })
)

(define-read-only (get-total-songs)
  (var-get total-songs)
)

(define-read-only (get-total-royalties-distributed)
  (var-get total-royalties-distributed)
)

(define-read-only (get-contract-stats)
  {
    total-songs: (var-get total-songs),
    total-royalties-distributed: (var-get total-royalties-distributed),
    contract-owner: CONTRACT_OWNER
  }
)
