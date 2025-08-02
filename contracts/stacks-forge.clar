;; StacksForge Protocol - Next-Generation Bitcoin Yield Optimization
;;
;; Title: StacksForge - Decentralized Bitcoin Capital Efficiency Engine
;;
;; Summary: Revolutionary DeFi infrastructure that unlocks the earning potential
;;          of idle Bitcoin through sophisticated algorithmic yield strategies,
;;          seamless sBTC integration, and autonomous reward optimization that
;;          delivers consistent returns while maintaining full asset custody
;;          and transparent risk management across all market conditions.
;;
;; Description: StacksForge represents the evolution of Bitcoin productivity,
;;              leveraging Stacks Layer 2 capabilities to create a robust
;;              yield generation ecosystem. Users can seamlessly deposit sBTC
;;              into intelligent vault strategies that employ dynamic staking
;;              algorithms, automated compound mechanisms, and adaptive period
;;              management. The protocol features decentralized governance,
;;              real-time analytics, transparent fee structures, and advanced
;;              risk mitigation systems designed to maximize capital efficiency
;;              while preserving the security and decentralization principles
;;              that make Bitcoin the world's premier digital asset.

;; ERROR CONSTANTS

(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_ZERO_STAKE (err u101))
(define-constant ERR_NO_STAKE_FOUND (err u102))
(define-constant ERR_TOO_EARLY_TO_UNSTAKE (err u103))
(define-constant ERR_INVALID_REWARD_RATE (err u104))
(define-constant ERR_NOT_ENOUGH_REWARDS (err u105))
(define-constant ERR_INVALID_PERIOD (err u106))
(define-constant ERR_OWNER_UNCHANGED (err u107))

;; DATA STORAGE STRUCTURES

;; User staking positions with comprehensive tracking
(define-map stakes
  { staker: principal }
  {
    amount: uint,
    staked-at: uint,
  }
)

;; Historical reward distribution ledger for complete transparency
(define-map rewards-claimed
  { staker: principal }
  { amount: uint }
)

;; PROTOCOL CONFIGURATION VARIABLES

;; Adaptive reward rate in basis points (dynamic yield optimization)
(define-data-var reward-rate uint u5)

;; Treasury pool for sustainable reward distribution
(define-data-var reward-pool uint u0)

;; Security-focused minimum lock period in blocks
(define-data-var min-stake-period uint u1440)

;; Total value locked (TVL) tracking across the protocol
(define-data-var total-staked uint u0)

;; Decentralized governance controller
(define-data-var contract-owner principal tx-sender)

;; ADMINISTRATIVE & GOVERNANCE FUNCTIONS

;; Retrieve current protocol administrator
(define-read-only (get-contract-owner)
  (var-get contract-owner)
)

;; Decentralized ownership transition mechanism
(define-public (set-contract-owner (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_NOT_AUTHORIZED)
    (asserts! (not (is-eq new-owner (var-get contract-owner)))
      ERR_OWNER_UNCHANGED
    )
    (ok (var-set contract-owner new-owner))
  )
)

;; Dynamic yield rate optimization (governance-controlled)
(define-public (set-reward-rate (new-rate uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_NOT_AUTHORIZED)
    (asserts! (< new-rate u1000) ERR_INVALID_REWARD_RATE)
    (ok (var-set reward-rate new-rate))
  )
)

;; Security parameter adjustment for minimum staking duration
(define-public (set-min-stake-period (new-period uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_NOT_AUTHORIZED)
    (asserts! (> new-period u0) ERR_INVALID_PERIOD)
    (ok (var-set min-stake-period new-period))
  )
)

;; Treasury funding mechanism for sustainable rewards
(define-public (add-to-reward-pool (amount uint))
  (begin
    (asserts! (> amount u0) ERR_ZERO_STAKE)
    ;; Secure sBTC transfer to protocol vault
    (try! (contract-call? 'ST1F7QA2MDF17S807EPA36TSS8AMEFY4KA9TVGWXT.sbtc-token
      transfer amount tx-sender (as-contract tx-sender) none
    ))
    ;; Expand reward distribution capacity
    (var-set reward-pool (+ (var-get reward-pool) amount))
    (ok true)
  )
)

;; CORE STAKING & YIELD GENERATION FUNCTIONS

;; Deposit sBTC into yield-generating vaults
(define-public (stake (amount uint))
  (begin
    (asserts! (> amount u0) ERR_ZERO_STAKE)
    ;; Execute secure token transfer to protocol custody
    (try! (contract-call? 'ST1F7QA2MDF17S807EPA36TSS8AMEFY4KA9TVGWXT.sbtc-token
      transfer amount tx-sender (as-contract tx-sender) none
    ))
    ;; Intelligent position management with compounding logic
    (match (map-get? stakes { staker: tx-sender })
      prev-stake
      ;; Compound existing position with optimized timing
      (map-set stakes { staker: tx-sender } {
        amount: (+ amount (get amount prev-stake)),
        staked-at: stacks-block-height,
      })
      ;; Initialize new yield-generating position
      (map-set stakes { staker: tx-sender } {
        amount: amount,
        staked-at: stacks-block-height,
      })
    )
    ;; Update protocol TVL metrics
    (var-set total-staked (+ (var-get total-staked) amount))
    (ok true)
  )
)

;; Advanced time-weighted reward calculation algorithm
(define-read-only (calculate-rewards (staker principal))
  (match (map-get? stakes { staker: staker })
    stake-info (let (
        (stake-amount (get amount stake-info))
        (stake-duration (- stacks-block-height (get staked-at stake-info)))
        (reward-basis (/ (* stake-amount (var-get reward-rate)) u1000))
        (blocks-per-year u52560)
        (time-factor (/ (* stake-duration u10000) blocks-per-year))
        (reward (* reward-basis (/ time-factor u10000)))
      )
      reward
    )
    u0
  )
)

;; Harvest accumulated yields without unstaking principal
(define-public (claim-rewards)
  (let (
      (stake-info (unwrap! (map-get? stakes { staker: tx-sender }) ERR_NO_STAKE_FOUND))
      (reward-amount (calculate-rewards tx-sender))
    )
    (asserts! (> reward-amount u0) ERR_NO_STAKE_FOUND)
    (asserts! (<= reward-amount (var-get reward-pool)) ERR_NOT_ENOUGH_REWARDS)
    ;; Treasury management and reward distribution
    (var-set reward-pool (- (var-get reward-pool) reward-amount))
    ;; Transparent reward tracking for audit purposes
    (match (map-get? rewards-claimed { staker: tx-sender })
      prev-claimed (map-set rewards-claimed { staker: tx-sender } { amount: (+ reward-amount (get amount prev-claimed)) })
      (map-set rewards-claimed { staker: tx-sender } { amount: reward-amount })
    )
    ;; Reset yield calculation baseline
    (map-set stakes { staker: tx-sender } {
      amount: (get amount stake-info),
      staked-at: stacks-block-height,
    })
    ;; Execute secure reward payout
    (as-contract (try! (contract-call? 'ST1F7QA2MDF17S807EPA36TSS8AMEFY4KA9TVGWXT.sbtc-token
      transfer reward-amount (as-contract tx-sender) tx-sender none
    )))
    (ok true)
  )
)

;; Withdraw staked assets with automatic yield harvesting
(define-public (unstake (amount uint))
  (let (
      (stake-info (unwrap! (map-get? stakes { staker: tx-sender }) ERR_NO_STAKE_FOUND))
      (staked-amount (get amount stake-info))
      (staked-at (get staked-at stake-info))
      (stake-duration (- stacks-block-height staked-at))
    )
    ;; Security validations and risk management
    (asserts! (> amount u0) ERR_ZERO_STAKE)
    (asserts! (>= staked-amount amount) ERR_NO_STAKE_FOUND)
    (asserts! (>= stake-duration (var-get min-stake-period))
      ERR_TOO_EARLY_TO_UNSTAKE
    )
    ;; Automatic yield harvesting before withdrawal
    (try! (claim-rewards))
    ;; Intelligent position management
    (if (> staked-amount amount)
      (map-set stakes { staker: tx-sender } {
        amount: (- staked-amount amount),
        staked-at: stacks-block-height,
      })
      (map-delete stakes { staker: tx-sender })
    )
    ;; Update protocol TVL accounting
    (var-set total-staked (- (var-get total-staked) amount))
    ;; Execute secure asset return to user
    (as-contract (try! (contract-call? 'ST1F7QA2MDF17S807EPA36TSS8AMEFY4KA9TVGWXT.sbtc-token
      transfer amount (as-contract tx-sender) tx-sender none
    )))
    (ok true)
  )
)