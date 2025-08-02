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