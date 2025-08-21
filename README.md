# 🎵 MRDistro - Decentralized Music Royalty Distribution

A smart contract system for automatically distributing music royalties to artists, songwriters, and producers in real-time on the Stacks blockchain.

## 🚀 Features

- **Automated Royalty Distribution** 🎯: Split income based on pre-agreed percentages
- **Real-time Payments** ⚡: Eliminate slow and opaque intermediaries
- **Multi-contributor Support** 👥: Support up to 20 contributors per song
- **Transparent Tracking** 📊: Track all earnings and withdrawals
- **Song Management** 🎼: Activate/deactivate songs as needed
- **Secure Withdrawals** 💰: Contributors can withdraw their earnings anytime

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

## 📖 Read-Only Functions

- `get-song-info`: Get song details and total earnings
- `get-song-royalty-split`: Get royalty split info for a contributor
- `get-user-balance`: Check user's balance and withdrawal history
- `get-song-contributors`: Get list of song contributors
- `get-total-songs`: Get total number of registered songs
- `get-total-royalties-distributed`: Get total royalties distributed
- `get-contract-stats`: Get overall contract statistics

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

## 🎯 Use Cases

- **Independent Artists** 🎤: Split streaming revenue automatically
- **Record Labels** 🏢: Manage complex royalty structures  
- **Songwriting Teams** ✍️: Fair distribution among co-writers
- **Producer Collaborations** 🎛️: Transparent producer royalties
- **Music Publishers** 📚: Automated publishing royalties

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

## 🚦 Getting Started

1. Deploy the MRDistro contract to Stacks
2. Register your songs with contributor splits
3. Distribute royalties as income flows in
4. Contributors withdraw earnings when ready

## 📄 License

MIT License - Feel free to use and modify for your music distribution needs!

---

*Built with ❤️ for the decentralized music ecosystem*
