-- Cleaning data in SQL series

SELECT *
FROM dbo.Nashville


-- Standarize date time

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM dbo.Nashville

UPDATE dbo.Nashville
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE Nashville
ADD SaleDateConverted Date

UPDATE dbo.Nashville
SET SaleDateConverted = CONVERT(Date, SaleDate)

--Populate property address data

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville a
JOIN Nashville b
  on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
   WHERE a.PropertyAddress is null

   UPDATE a
   SET PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
   FROM Nashville a
   JOIN Nashville b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

--Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM NashvilleHouse.dbo.Nashville

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1,LEN(PropertyAddress)) AS 

FROM NashvilleHouse.dbo.Nashville  

ALTER TABLE NashvilleHouse.dbo.Nashville
ADD PropertySplitAddress Nvarchar(255)

UPDATE NashvilleHouse.dbo.Nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1)

ALTER TABLE NashvilleHouse.dbo.Nashville
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvilleHouse.dbo.Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1,LEN(PropertyAddress))

--Cleaning owner address column

SELECT OwnerAddress
FROM NashvilleHouse.dbo.Nashville

SELECT PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM NashvilleHouse.dbo.Nashville

ALTER TABLE NashvilleHouse.dbo.Nashville
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashvilleHouse.dbo.Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE NashvilleHouse.dbo.Nashville
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashvilleHouse.dbo.Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHouse.dbo.Nashville
ADD OwnerSplitState Nvarchar (255)

UPDATE NashvilleHouse.dbo.Nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

--Change Y and N to Yes and No in 'Sold as Vacant' field

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHouse.dbo.Nashville
GROUP BY SoldAsVacant
ORDER BY 2 DESC


SELECT SoldAsVacant,
 CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
      WHEN SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END
FROM NashvilleHouse.dbo.Nashville


UPDATE NashvilleHouse.dbo.Nashville
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
      WHEN SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END
 

 --Remove Duplicates


WITH RowNumCTE AS (
SELECT *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) row_num
FROM NashvilleHouse.dbo.Nashville
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


-- Delete unused columns

SELECT *
FROM NashvilleHouse.dbo.Nashville

ALTER TABLE NashvilleHouse.dbo.Nashville
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

ALTER TABLE NashvilleHouse.dbo.Nashville
DROP COLUMN SaleDate





