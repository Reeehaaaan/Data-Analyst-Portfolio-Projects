SELECT *
FROM [Data Cleaning Portfolio project]..housing
;

-- CONVERTING SaleDate date format

SELECT SalesDate, CONVERT(DATE,SaleDate) AS remove_at_the_ends
FROM [Data Cleaning Portfolio project]..housing
;

UPDATE housing 
SET SaleDate = CONVERT(DATE,SaleDate)

ALTER TABLE housing
ADD SalesDate DATE;

UPDATE housing
SET SalesDate = CONVERT(DATE,SaleDate)


-- Populating missing data in Address data

SELECT *
FROM [Data Cleaning Portfolio project]..housing
WHERE PropertyAddress IS NULL
;

SELECT a.ParcelID, a.PropertyAddress, a.ParcelID,b.PropertyAddress, ISNULL(A.PropertyAddress, b.PropertyAddress)
FROM [Data Cleaning Portfolio project]..housing AS a
JOIN [Data Cleaning Portfolio project]..housing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress IS NULL
;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Data Cleaning Portfolio project]..housing AS a
JOIN [Data Cleaning Portfolio project]..housing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress IS NULL
; -- UPDATED PROPERTY ADDRESS


SELECT * FROM [Data Cleaning Portfolio project]..housing WHERE PropertyAddress IS NULL


-- Breaking out address into individual columns

SELECT SUBSTRING(PropertyAddress ,1,CHARINDEX(',',PropertyAddress) - 1) AS street ,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress)) AS place
FROM [Data Cleaning Portfolio project]..housing
;


ALTER TABLE housing
ADD PropertyAddressStreet VARCHAR(255) ;

UPDATE housing
SET PropertyAddressStreet = SUBSTRING(PropertyAddress ,1,CHARINDEX(',',PropertyAddress) - 1)

ALTER TABLE [Data Cleaning Portfolio project]..housing
ADD PropertyAddressPlaces VARCHAR(255) ;

UPDATE housing
SET PropertyAddressPlaces = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress))

-- ALTER TABLE [Data Cleaning Portfolio project]..housing
-- DROP COLUMN PropertyAddressPlace
;

-- ALTER TABLE [Data Cleaning Portfolio project]..housing
-- DROP COLUMN SplitPropertyAddress

SELECT *
FROM [Data Cleaning Portfolio project]..housing
; 


-- Breaking out owner address into individual columns

SELECT OwnerAddress
FROM [Data Cleaning Portfolio project]..housing;

SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3), -- PARSENAME RETURNS BACK THE STR UNTIL A PERIOD EX - REHAN. RETURNS REHAN
PARSENAME (REPLACE(OwnerAddress,',','.'),2),	   -- SINCE OwnerAddress DOES NOT HAVE PERIOD USING REPLACE BUTTON TO REPLACE COMMAS WITH PERIOD 
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM [Data Cleaning Portfolio project]..housing
ORDER BY 3 DESC
;

ALTER TABLE [Data Cleaning Portfolio project]..housing
ADD OwnerAddressStreet nvarchar(255);

UPDATE housing
SET OwnerAddressStreet = PARSENAME(REPLACE(OwnerAddress,',','.'),3);


ALTER TABLE [Data Cleaning Portfolio project]..housing
ADD OwnerAddressCity nvarchar(255);

UPDATE housing 
SET OwnerAddressCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);

ALTER TABLE [Data Cleaning Portfolio project]..housing
ADD OwnerAddressState nvarchar(255);

UPDATE housing
SET OwnerAddressState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);


SELECT * FROM [Data Cleaning Portfolio project]..housing;

-- CHANGING 'Y' AND 'N' TO 'YES' AND 'NO'

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [Data Cleaning Portfolio project]..housing	
GROUP BY SoldAsVacant
ORDER BY 2
;

SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM [Data Cleaning Portfolio project]..housing
;

UPDATE housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' WHEN SoldAsVacant = 'N' THEN 'No' ELSE SoldAsVacant END
;


SELECT * FROM [Data Cleaning Portfolio project]..housing;


-- REMOVING DUPLICATES FROM TABLE

WITH RowNumberCTE AS -- TO CHECK DUPLICATE ROWS
(
SELECT * ,ROW_NUMBER () OVER (PARTITION BY ParcelID,LandUse,PropertyAddress,LegalReference ORDER BY UniqueID) AS row_num
FROM [Data Cleaning Portfolio project]..housing
)
SELECT *
FROM RowNumberCTE
WHERE row_num > 1


WITH RowNumberCTE AS -- TO DELETE DUPLICATE ROWS
(
SELECT * ,ROW_NUMBER () OVER (PARTITION BY ParcelID,LandUse,PropertyAddress,LegalReference ORDER BY UniqueID) AS row_num
FROM [Data Cleaning Portfolio project]..housing
)
DELETE	
FROM RowNumberCTE
WHERE row_num > 1
;


SELECT * FROM [Data Cleaning Portfolio project]..housing;

ALTER TABLE [Data Cleaning Portfolio project]..housing
DROP COLUMN OwnerName, OwnerAddress,Acreage,TaxDistrict,LandValue,BuildingValue,TotalValue,YearBuilt,Bedrooms,FullBath,Halfbath,SaleDate,PropertyAddress


SELECT * FROM [Data Cleaning Portfolio project]..housing;

