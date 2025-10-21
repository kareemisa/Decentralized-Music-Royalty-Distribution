# 🎵 MRDistro - Decentralized Music Royalty Distribution

A smart contract system for automatically distributing music royalties to artists, songwriters, and producers in real-time on the Stacks blockchain.

## 🚀 Features

- **Automated Royalty Distribution** 🎯: Split income based on pre-agreed percentages
- **Real-time Payments** ⚡: Eliminate slow and opaque intermediaries
- **Multi-contributor Support** 👥: Support up to 20 contributors per song
- **Transparent Tracking** 📊: Track all earnings and withdrawals
- **Song Management** 🎼: Activate/deactivate songs as needed
- **Secure Withdrawals** 💰: Contributors can withdraw their earnings anytime
- **🆕 Royalty Escrow System** 🔒: Lock funds for milestone-based or time-locked releases
- **🆕 Advance Funding** 💸: Artists can receive immediate capital against future royalties

## 📋 Contract Functions

### 🎼 Song Registration
```clarity
(register-song title contributors percentages)
```
Register a new song with contributors and their royalty percentages (must sum to 100%).

### 💸 Royalty Distribution
```clarity
(distribute-royalties song-id amount)
```
Distribute royalties for a specific song to all contributors based on their percentages.

### 💰 Withdraw Earnings
```clarity
(withdraw-earnings)
```
Contributors can withdraw their accumulated earnings.

### 🔧 Song Management
```clarity
(deactivate-song song-id)
(activate-song song-id)
```
Song owners can activate or deactivate their songs.

### 🔒 Escrow Management
```clarity
(create-escrow beneficiary cliff-height milestones)
```
Create a new escrow with milestone-based or time-locked fund releases.

```clarity
(approve-milestone escrow-id milestone-id)
```
Artist approves milestone completion, releasing funds to beneficiary.

```clarity
(claim-time-locked-escrow escrow-id)
```
Beneficiary claims funds after cliff period expires.

```clarity
(cancel-escrow escrow-id)
```
Artist cancels active escrow and recovers unreleased funds.

## 📖 Read-Only Functions

- `get-song-info`: Get song details and total earnings
- `get-song-royalty-split`: Get royalty split info for a contributor
- `get-user-balance`: Check user's balance and withdrawal history
- `get-song-contributors`: Get list of song contributors
- `get-total-songs`: Get total number of registered songs
- `get-total-royalties-distributed`: Get total royalties distributed
- `get-contract-stats`: Get overall contract statistics
- `get-escrow-info`: Get escrow details and status
- `get-escrow-milestone`: Get specific milestone information
- `get-total-escrows`: Get total number of created escrows

## 🛠️ Usage Examples

### Register a Song
```clarity
(contract-call? .MRDistro register-song 
  "My Awesome Song"
  (list 'SP1ARTIST 'SP2PRODUCER 'SP3SONGWRITER)
  (list u50 u30 u20))
```

### Distribute Royalties
```clarity
(contract-call? .MRDistro distribute-royalties u1 u1000000)
```

### Withdraw Earnings
```clarity
(contract-call? .MRDistro withdraw-earnings)
```

### Check Your Balance
```clarity
(contract-call? .MRDistro get-user-balance 'SP1YOUR-ADDRESS)
```

### Create an Escrow
```clarity
(contract-call? .MRDistro create-escrow 
  'SP1BENEFICIARY 
  u144000 
  (list u500000 u300000 u200000))
```

### Approve Milestone
```clarity
(contract-call? .MRDistro approve-milestone u1 u0)
```

### Claim Time-Locked Escrow
```clarity
(contract-call? .MRDistro claim-time-locked-escrow u1)
```

## 🎯 Use Cases

- **Independent Artists** 🎤: Split streaming revenue automatically
- **Record Labels** 🏢: Manage complex royalty structures  
- **Songwriting Teams** ✍️: Fair distribution among co-writers
- **Producer Collaborations** 🎛️: Transparent producer royalties
- **Music Publishers** 📚: Automated publishing royalties
- **🆕 Advance Funding** 💰: Artists receive upfront capital for production
- **🆕 Investment Protection** 🛡️: Milestone-based fund release for investors

## 🔒 Security Features

- Only song owners can activate/deactivate their songs
- Percentage validation ensures splits always equal 100%
- Secure withdrawal mechanism with balance tracking
- Protected against unauthorized access

## 📈 Contract Statistics

Track the growth and usage of the platform:
- Total songs registered
- Total royalties distributed  
- Individual user earnings and withdrawals
- Total escrows created and managed
- Milestone completion rates

## 🚦 Getting Started

1. Deploy the MRDistro contract to Stacks
2. Register your songs with contributor splits
3. Distribute royalties as income flows in
4. Contributors withdraw earnings when ready

## 📄 License

MIT License - Feel free to use and modify for your music distribution needs!

---

*Built with ❤️ for the decentralized music ecosystem*
