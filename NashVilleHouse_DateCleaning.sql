/*

Cleaning Data in SQL Queries

*/


Select * from PortfolioProject..NashvilleHousing


-- Standardize Date Format

Select saledateconverted, convert(date,SaleDate)
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SaleDate= convert(date,SaleDate)


Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted= convert(date,SaleDate)


--- Populate Property Address data

Select * 
from PortfolioProject..NashvilleHousing
--where Propertyaddress is null
order by ParcelID

Select Propertyaddress
from PortfolioProject..NashvilleHousing
where Propertyaddress is null


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, IsNull(a.propertyaddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null


 Update a
 SET PropertyAddress= IsNull(a.propertyaddress,b.PropertyAddress)
 from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null


----Breaking out Address into Individual Columns (Address,City, State)

 Select Propertyaddress
 from PortfolioProject..NashvilleHousing
 --where Propertyaddress is null
--order by ParcelID

-- Include comma +1, take it off -1

Select
SUBSTRING(PropertyAddress, 1, CharINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CharINDEX(',',PropertyAddress) +1, Len(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress NVarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CharINDEX(',',PropertyAddress) -1)


Alter Table NashvilleHousing
Add PropertySplitCity NVarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CharINDEX(',',PropertyAddress) +1, Len(PropertyAddress))


Select * 
From PortfolioProject..NashvilleHousing





Select OwnerAddress
From PortfolioProject..NashvilleHousing

select 
PARSENAME(Replace(OwnerAddress,',', '.' ), 1)
,PARSENAME(Replace(OwnerAddress,',', '.' ), 2)
,PARSENAME(Replace(OwnerAddress,',', '.' ), 3)
From PortfolioProject..NashvilleHousing



Alter Table NashvilleHousing
Add OwnerSplitAddress NVarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',', '.' ), 3)


Alter Table NashvilleHousing
Add OwnerSplitCity NVarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',', '.' ), 2)

Alter Table NashvilleHousing
Add OwnerSplitState NVarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',', '.' ), 1)

Select *
From PortfolioProject..NashvilleHousing



---- Change Y and N to Yes and No in "Sold as Vacant" field


Select distinct(SoldasVacant), Count(SoldasVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant ='N' Then 'No'
	   Else SoldAsVacant
	   END
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant= Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant ='N' Then 'No'
	   Else SoldAsVacant
	   END



--- REMOVE DUPLICATES

WITH RowNUMCTE As(
Select *,
  Row_Number() OVER(
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY 
			      UniqueID
				  ) row_num


From PortfolioProject..NashvilleHousing
--order by ParcelID

)
Select * -- Delete from 
From RowNUMCTE
where row_num >1 
Order by PropertyAddress

--- After Creating CTE and running  later used Delete, which deleted all duplicates


Select *
From PortfolioProject..NashvilleHousing



---- Delete Unused Columns 

Select *
From PortfolioProject..NashvilleHousing


ALTER Table PortfolioProject..NashvilleHousing
DROP Column OwnerAddress, TaxDistrict, PropertyAddress


ALTER Table PortfolioProject..NashvilleHousing
DROP Column SaleDate