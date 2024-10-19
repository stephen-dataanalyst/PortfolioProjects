/* 

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDate, Convert(Date, SaleDate)
From PortfolioProject..NashvilleHousing

ALTER Table NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
Set SaleDateConverted = Convert(Date, SaleDate)

--------------------------------------------------------------------------------------------------------------

--Populate Property Address Data

Select *
From PortfolioProject..NashvilleHousing
--where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID =  b.ParcelID 
	and a.UniqueID <> b.UniqueID
	where  a.PropertyAddress is null


Update a 
Set a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID =  b.ParcelID 
	and a.UniqueID <> b.UniqueID
	where  a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------

--Breaking Out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing

SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing


ALTER Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

ALTER Table NashvilleHousing
Add PropertySplitCity Nvarchar(255) 

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


Select *
From PortfolioProject..NashvilleHousing





Select OwnerAddress
From PortfolioProject..NashvilleHousing


Select 
PARSENAME(Replace(OwnerAddress, ',', '.'),3)
, PARSENAME(Replace(OwnerAddress, ',', '.'),2)
, PARSENAME(Replace(OwnerAddress, ',', '.'),1)
From PortfolioProject..NashvilleHousing


ALTER Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'),3)

ALTER Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2)


ALTER Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'),1)



Select *
From PortfolioProject..NashvilleHousing



--------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No "Sold as Vacant" field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
,CASE
	When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldASVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
End
From PortfolioProject..NashvilleHousing
Where SoldAsVacant in ('Y', 'N')


Update NashvilleHousing
Set SoldAsVacant= CASE
	When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldASVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
End



---------------------------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE as (
Select *, 
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order BY UniqueID
				 ) row_num
From PortfolioProject..NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
where row_num > 1


---------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

Select *
From PortfolioProject..NashvilleHousing


ALTER Table NashvilleHousing
DROP column SaleDate, OwnerAddress, TaxDistrict, PropertyAddress













--------------------------------------------------------------------------------------------------------



