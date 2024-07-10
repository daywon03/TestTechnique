
---

# CryptoWines

CryptoWines est un contrat intelligent Ethereum permettant la création, la vente et le transfert de jetons non fongibles (NFT) représentant des bouteilles de vin.

## Description

Ce contrat intelligent permet aux utilisateurs de :
- Créer de nouveaux NFT représentant des bouteilles de vin.
- Définir des prix pour les NFT.
- Acheter des NFT avec de l'Ether.
- Transférer des NFT entre utilisateurs.
- Retirer les fonds accumulés dans le contrat.

## Fonctionnalités

### Création de NFT

Le propriétaire du contrat peut créer de nouveaux NFT avec une URI spécifiant les métadonnées du NFT.

### Définition des Prix

Les propriétaires de NFT peuvent définir le prix de vente de leurs NFT.

### Achat de NFT

Les utilisateurs peuvent acheter des NFT disponibles en envoyant le montant d'Ether spécifié au vendeur.

### Transfert de NFT

Les propriétaires de NFT peuvent transférer leurs NFT à d'autres utilisateurs.

### Retrait des Fonds

Le propriétaire du contrat peut retirer les fonds accumulés dans le contrat.

## Déploiement

Pour déployer ce contrat, suivez ces étapes :

1. Installez les dépendances nécessaires :
    ```bash
    npm install @openzeppelin/contracts
    ```

2. Déployez le contrat sur le réseau Ethereum de votre choix.

## Utilisation

### Création de NFT

Pour créer un nouveau NFT, le propriétaire du contrat doit appeler la fonction `mint` :

```solidity
function mint(address vOwner, uint256 _tokenId, string calldata _uri) external onlyOwner {
    _mint(vOwner, _tokenId); 
    _setTokenURI(_tokenId, _uri);
}
```

### Définition des Prix

Pour définir le prix d'un NFT, le propriétaire du NFT doit appeler la fonction `setPrice` :

```solidity
function setPrice(uint256 _tokenId, uint256 _price) external {
    require(msg.sender == ownerOf(_tokenId), "Not owner of this token");
    tokenIdToPrice[_tokenId] = _price;
}
```

### Achat de NFT

Pour acheter un NFT, un utilisateur doit appeler la fonction `buy` en envoyant le montant d'Ether spécifié :

```solidity
function buy(uint256 _tokenId) external payable {
    uint256 price = tokenIdToPrice[_tokenId];
    require(price > 0, "This token is not for sale");
    require(msg.value == price, "Incorrect value");
    address seller = ownerOf(_tokenId);
    payable(seller).transfer(msg.value);
    tokenIdToPrice[_tokenId] = 0;
    emit NftBought(seller, msg.sender, price);
}
```

### Transfert de NFT

Pour transférer un NFT, le propriétaire du NFT doit appeler la fonction `transferNFT` :

```solidity
function transferNFT(address from, address to, uint256 tokenId) external {
    require(ownerOf(tokenId) == from, "Sender is not the owner");
    safeTransferFrom(from, to, tokenId);
}
```

### Retrait des Fonds

Pour retirer les fonds accumulés dans le contrat, le propriétaire du contrat doit appeler la fonction `withdraw` :

```solidity
function withdraw() external onlyOwner {
    (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
    require(callSuccess, "Call failed");
}
```

## Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## Remerciements

- [OpenZeppelin](https://openzeppelin.com/) pour leurs contrats Solidity sécurisés et réutilisables.

---
