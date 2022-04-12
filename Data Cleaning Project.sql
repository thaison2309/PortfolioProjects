use PortfolioProject
go

select * from NashvilleHousing

-- Standard date format

update NashvilleHousing
set saledate = CONVERT(date, saledate) -- this does not working for some reasons

alter table NashvilleHousing add SaleDateConverted date
update NashvilleHousing
set SaleDateConverted = CONVERT(date, saledate)

select * from NashvilleHousing

-- Populate Property Address data


-- selecting property address if it is null and search for its value
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is  null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- breaking down address into individual columns (address, city, state)
select  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
		SUBSTRING(PropertyAddress, (CHARINDEX(',', PropertyAddress)+1) , len(PropertyAddress)) as city
from NashvilleHousing

alter table nashvilleHousing add propertySplitAddress varchar(255), propertySplitCity varchar(255) 

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1),
	PropertySplitCity = SUBSTRING(PropertyAddress, (CHARINDEX(',', PropertyAddress)+1) , len(PropertyAddress))

-- split state
 select 
 PARSENAME(replace(OwnerAddress,',','.'),1) -- parsename work with '.'
 PARSENAME(replace(OwnerAddress,',','.'),2) -- parsename work with '.' 
 PARSENAME(replace(OwnerAddress,',','.'),3) -- parsename work with '.' 
 from NashvilleHousing

 alter table nashvilleHousing add   ownerSplitAddress nvarchar(255), 
									ownerSplitCity nvarchar(255),	
									ownerSplitState nvarchar(255)
update NashvilleHousing
set OwnerSplitAddress  =  PARSENAME(replace(OwnerAddress,',','.'),3)

update NashvilleHousing
set OwnerSplitCity  =  PARSENAME(replace(OwnerAddress,',','.'),2)

update NashvilleHousing
set OwnerSplitState  =  PARSENAME(replace(OwnerAddress,',','.'),1)

select * from NashvilleHousing 


-- Change Y and N to Yes and No in 'soldAsVacant' field

select distinct(soldAsVacant) from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'		
						when SoldAsVacant = 'N' then 'No'
						else SoldAsVacant
						end
-- Remove duplicate
with rownumCTE as (
select *, ROW_NUMBER() over (partition by ParcelID, 
										  PropertyAddress,
										  SalePrice, SaleDate,
										  LegalReference
										  order by uniqueID) rownum
from NashvilleHousing
)

Delete from rownumCTE
where rownum > 1 


-- delete unused column

select * from NashvilleHousing
alter table nashvilleHousing
drop column owneraddress, Taxdistrict, PropertyAddress, saledate

