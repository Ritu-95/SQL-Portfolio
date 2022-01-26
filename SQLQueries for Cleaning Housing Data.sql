--Clean Data in SQL
Select * 
from PortfolioProject.dbo.Housing

--Standardize Date format
select SaleDate
from PortfolioProject.dbo.Housing

Select Convert(Date,SaleDate)
from PortfolioProject.dbo.Housing
Alter Table dbo.Housing
Add SaleDateConverted Date

Update dbo.Housing
Set SaleDateConverted = Convert(Date,SaleDate)


select SaleDateConverted
from PortfolioProject.dbo.Housing

----  Property Addressbeing populated 
Select *
from dbo.Housing 
where PropertyAddress is Null
order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.Housing a 
Join dbo.Housing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is Null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.Housing a 
Join dbo.Housing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is Null

-----Braking the Address into columns like Address,City,State
Select PropertyAddress
from dbo.Housing 

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) as Address1
from dbo.Housing 

Alter Table Housing
Add SpiltPropertyAddress varchar(255)

Update Housing
Set SpiltPropertyAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

Select SpiltPropertyAddress
from dbo.Housing

Alter Table Housing
Add SpiltPropertyAddressCity varchar(255)

Update Housing 
Set SpiltPropertyAddressCity=substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))

Select SpiltPropertyAddressCity
from dbo.Housing

Select OwnerAddress
from dbo.Housing,

Select
 PARSENAME(Replace(OwnerAddress, ',', '.'),3),
 PARSENAME(Replace(OwnerAddress, ',', '.'),2),
 PARSENAME(Replace(OwnerAddress, ',', '.'),1)
from dbo.Housing

Alter Table Housing
Add OwnerSplitAddress varchar(255)

Update Housing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'),3)

Select OwnerSplitAddress
from Housing

Alter Table Housing
Add OwnerSplitAddressCity varchar(255)

Update Housing
set OwnerSplitAddressCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2)

Alter Table Housing
Add OwnerSpiltAddressState varchar(255)

Update Housing
set OwnerSpiltAddressState= PARSENAME(Replace(OwnerAddress, ',', '.'),1)

Select  OwnerSplitAddress,OwnerSplitAddressCity,OwnerSpiltAddressState
from Housing


-----Change 'Y' to 'Yes' and 'N' to 'NO' in SoldAsVacant column

select Distinct(SoldAsVacant),Count(SoldAsVacant) 
from Housing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
	CASE When SoldAsVacant = 'N' then 'No'
		 When  SoldAsVacant = 'Y' then 'Yes'
		 Else SoldAsVacant
		 END
from Housing

Update Housing
Set SoldAsVacant =CASE When SoldAsVacant = 'N' then 'No'
		 When  SoldAsVacant = 'Y' then 'Yes'
		 Else SoldAsVacant
		 END
from dbo.Housing

---Remove Duplicate

Select * 
from dbo.Housing

With RowNumCTE As(
select *,
	ROW_NUMBER() Over (
	Partition By ParcelID,
			PropertyAddress,
			SaleDate,
			SalePrice,
			LegalReference
				order by
				UniqueID
					)row_num
from dbo.Housing
)

Select *
from RowNumCTE	
where row_num >1


-----Remove unwanted columns

Select *
from dbo.Housing

Alter table dbo.Housing
Drop column PropertyAddress,SaleDate,OwnerAddress,TaxDistrict

		 

	


