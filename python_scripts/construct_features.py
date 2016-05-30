# This code extract the features from the raw joined dataset (data.csv)
# and save it in the LibSVM format.
# Usage: python construct_features.py

import pandas as pd
import numpy as np
from sklearn.datasets import dump_svmlight_file

df = pd.read_csv("data.csv", low_memory=False)

# NPU

NPU = df.NPU.copy()
NPU[NPU == ' '] = np.nan
NPU = pd.get_dummies(NPU, prefix="NPU")

# SiteZip

SiteZip = df.SiteZip.copy()
SiteZip = SiteZip.str.replace(',','')
SiteZip = SiteZip.str.replace('\.00','')
SiteZip = SiteZip.replace('0',np.nan)
SiteZip = pd.get_dummies(SiteZip, prefix="SiteZip")


# Submarket1


Submarket1 = df.Submarket1.copy()
Submarket1 = pd.get_dummies(Submarket1, prefix="Submarket1")


# TAX_DISTR


TAX_DISTR = df.TAX_DISTR.copy()
TAX_DISTR[TAX_DISTR == ' '] = np.nan
TAX_DISTR = pd.get_dummies(TAX_DISTR, prefix="TAX_DISTR")


# NBHD


NBHD = df.NBHD.copy()
NBHD[NBHD == ' '] = np.nan
NBHD = pd.get_dummies(NBHD, prefix="NBHD")


# ZONING_NUM


ZONING_NUM = df.ZONING_NUM.copy()
ZONING_NUM[ZONING_NUM == ' '] = np.nan
ZONING_NUM = pd.get_dummies(ZONING_NUM, prefix="ZONING_NUM")


# building_c


building_c = df.building_c.copy()
building_c[building_c == ' '] = np.nan
building_c = pd.get_dummies(building_c, prefix="building_c")


# PROP_CLASS


PROP_CLASS = df.PROP_CLASS.copy()
PROP_CLASS[PROP_CLASS == ' '] = np.nan
PROP_CLASS = pd.get_dummies(PROP_CLASS, prefix="PROP_CLASS")


# Existing_p


Existing_p = df.Existing_p.copy()
Existing_p[Existing_p == ' '] = np.nan
Existing_p = pd.get_dummies(Existing_p, prefix="Existing_p")


# PropertyTy


PropertyTy = df.PropertyTy.copy()
PropertyTy = pd.get_dummies(PropertyTy, prefix="PropertyTy")


# secondaryT


secondaryT = df.secondaryT.copy()
secondaryT[secondaryT == ' '] = np.nan
secondaryT = pd.get_dummies(secondaryT, prefix="secondaryT")


# LUC


LUC = df.LUC.copy()
LUC[LUC == ' '] = np.nan
LUC = pd.get_dummies(LUC, prefix="LUC")


# Taxes_Per_


Taxes_Per_ = df.Taxes_Per_.copy()
Taxes_Per_zero = (Taxes_Per_ == "0").apply(int)
Taxes_Per_zero.name = 'Taxes_Per_zero'
Taxes_Per_ = Taxes_Per_.str.replace(',','').astype(float)
Taxes_Per_ = np.log1p(Taxes_Per_)
Taxes_Per_ = Taxes_Per_ / Taxes_Per_.max()
Taxes_Per_ = pd.concat([Taxes_Per_, Taxes_Per_zero], axis=1)


# Taxes_Tota


Taxes_Tota = df.Taxes_Tota.copy()
Taxes_Tota_zero = (Taxes_Tota == "0").apply(int)
Taxes_Tota_zero.name = 'Taxes_Tota_zero'
Taxes_Tota = Taxes_Tota.str.replace(',','').astype(float)
Taxes_Tota = np.log1p(Taxes_Tota)
Taxes_Tota = Taxes_Tota / Taxes_Tota.max()
Taxes_Tota = pd.concat([Taxes_Tota, Taxes_Tota_zero], axis=1)


# TOT_APPR


TOT_APPR = df.TOT_APPR.copy()
TOT_APPR_zero = (TOT_APPR == "0").apply(int)
TOT_APPR_zero.name = 'TOT_APPR_zero'
TOT_APPR = TOT_APPR.str.replace(',','').astype(float)
TOT_APPR = np.log1p(TOT_APPR)
TOT_APPR = TOT_APPR / TOT_APPR.max()
TOT_APPR = pd.concat([TOT_APPR, TOT_APPR_zero], axis=1)


# VAL_ACRES


VAL_ACRES = df.VAL_ACRES.copy()
VAL_ACRES_zero = (VAL_ACRES == 0).apply(int)
VAL_ACRES_zero.name = 'VAL_ACRES_zero'
VAL_ACRES = np.log1p(VAL_ACRES)
VAL_ACRES = VAL_ACRES / VAL_ACRES.max()
VAL_ACRES = pd.concat([VAL_ACRES, VAL_ACRES_zero], axis=1)


# For_Sale_P


For_Sale_P = df.For_Sale_P.copy()
For_Sale_P_notNA = (For_Sale_P != " ").apply(int)
For_Sale_P_notNA.name = 'For_Sale_P_notNA'
For_Sale_P[For_Sale_P == ' '] = 0
For_Sale_P = For_Sale_P.astype(float)
For_Sale_P = np.log1p(For_Sale_P)
For_Sale_P = For_Sale_P / For_Sale_P.max()
For_Sale_P = pd.concat([For_Sale_P, For_Sale_P_notNA], axis=1)


# Last_Sale1


Last_Sale1 = df.Last_Sale1.copy()
Last_Sale1_zero = (Last_Sale1 == "0").apply(int)
Last_Sale1_zero.name = "Last_Sale1_zero"
Last_Sale1 = Last_Sale1.str.replace(',','').astype(float)
Last_Sale1 = np.log1p(Last_Sale1)
Last_Sale1 = (Last_Sale1 - Last_Sale1.min()) / (Last_Sale1.max() - Last_Sale1.min())
Last_Sale1 = pd.concat([Last_Sale1, Last_Sale1_zero], axis=1)


# yearbuilt


yearbuilt = df.yearbuilt.copy()
yearbuilt_zero = (yearbuilt == "0").apply(int)
yearbuilt_zero.name = "yearbuilt_zero"
yearbuilt[yearbuilt == "0"] = np.nan
yearbuilt = yearbuilt.str.replace(',','').astype(float)
yearbuilt = (yearbuilt - yearbuilt.min()) / (yearbuilt.max() - yearbuilt.min())
yearbuilt = yearbuilt.fillna(0)
yearbuilt = pd.concat([yearbuilt, yearbuilt_zero], axis=1)


# year_reno


year_reno = df.year_reno.copy()
reno = (year_reno != "0").apply(int)
reno.name = "reno"
year_reno[year_reno == "0"] = np.nan
year_reno = year_reno.str.replace(',','').astype(float)
year_reno = (year_reno - year_reno.min()) / (year_reno.max() - year_reno.min())
year_reno = year_reno.fillna(0)
year_reno = pd.concat([year_reno, reno], axis=1)


# Lot_Condition


Lot_Condition = df.Lot_Condition.copy()
Lot_Condition[Lot_Condition == ' '] = np.nan
Lot_Condition = pd.get_dummies(Lot_Condition, prefix="Lot_Condition")


# Structure_Condition


Structure_Condition = df.Structure_Condition.copy()
Structure_Condition[Structure_Condition == ' '] = np.nan
Structure_Condition = pd.get_dummies(Structure_Condition, prefix="Structure_Condition")


# Sidewalks


Sidewalks = df.Sidewalks.copy()
Sidewalks[Sidewalks == "YES"] = "Yes"
Sidewalks[Sidewalks == " "] = np.nan
Sidewalks = pd.get_dummies(Sidewalks, prefix="Sidewalks")


# Multiple_Violations


Multiple_Violations = df.Multiple_Violations.copy()
Multiple_Violations[Multiple_Violations == ' '] = np.nan
Multiple_Violations = pd.get_dummies(Multiple_Violations, prefix="Multiple_Violations")


# Vacancy_pc


Vacancy_pc = df.Vacancy_pc.copy()
Vacancy_pc_nonzero = (Vacancy_pc != 0).apply(int)
Vacancy_pc_nonzero.name = "Vacancy_pc_nonzero"
Vacancy_pc = Vacancy_pc / Vacancy_pc.max()
Vacancy_pc = pd.concat([Vacancy_pc, Vacancy_pc_nonzero], axis=1)


# Total_Avai


Total_Avai = df.Total_Avai.copy()
Total_Avai_nonzero = (Total_Avai != "0").apply(int)
Total_Avai_nonzero.name = "Total_Avai_nonzero"
Total_Avai = Total_Avai.str.replace(',','').astype(float)
Total_Avai = np.log1p(Total_Avai)
Total_Avai = (Total_Avai - Total_Avai.min()) / (Total_Avai.max() - Total_Avai.min())
Total_Avai = pd.concat([Total_Avai, Total_Avai_nonzero], axis=1)


# Percent_Le


Percent_Le = df.Percent_Le.copy()
Percent_Le_bin = (Percent_Le == 100).apply(int) 
Percent_Le_bin[Percent_Le == 0] = -1
Percent_Le_bin.name = "Percent_Le_bin"
Percent_Le = Percent_Le / Percent_Le.max()
Percent_Le = pd.concat([Percent_Le, Percent_Le_bin], axis=1)


# LandArea_a


LandArea_a = df.LandArea_a.copy()
LandArea_a_zero = (LandArea_a == "0").apply(int)
LandArea_a_zero.name = "LandArea_a_zero"
LandArea_a = LandArea_a.str.replace(',','').astype(float)
LandArea_a = np.log1p(LandArea_a)
LandArea_a = LandArea_a / LandArea_a.max()
LandArea_a = pd.concat([LandArea_a, LandArea_a_zero], axis=1)


# totalbuild


totalbuild = df.totalbuild.copy()
totalbuild_nonzero = (totalbuild != 0).apply(int)
totalbuild_nonzero.name = "totalbuild_nonzero"
totalbuild = np.log1p(totalbuild)
totalbuild = totalbuild / totalbuild.max()
totalbuild = pd.concat([totalbuild, totalbuild_nonzero], axis=1)


# avg_sf


avg_sf = df.avg_sf.copy()
avg_sf_nonzero = (avg_sf != "0").apply(int)
avg_sf_nonzero.name = "avg_sf_nonzero"
avg_sf[avg_sf == "0"] = np.nan
avg_sf = avg_sf.str.replace(',','').astype(float)
avg_sf = (avg_sf - avg_sf.min()) / (avg_sf.max() - avg_sf.min()) 
avg_sf = avg_sf.fillna(0)
avg_sf = pd.concat([avg_sf, avg_sf_nonzero], axis=1)


# Floorsize


Floorsize = df.Floorsize.copy()
Floorsize[Floorsize == "0"] = np.nan
Floorsize = Floorsize.str.replace(',','').astype(float)
Floorsize = np.log1p(Floorsize)
Floorsize = (Floorsize - Floorsize.min()) / (Floorsize.max() - Floorsize.min())
Floorsize = Floorsize.fillna(Floorsize.median())


# BldgSF


BldgSF = df.BldgSF.copy()
BldgSF_zero = (BldgSF == "0").apply(int)
BldgSF_zero.name = "BldgSF_zero"
BldgSF = BldgSF.str.replace(',','').astype(float)
BldgSF = np.log1p(BldgSF)
BldgSF = BldgSF / BldgSF.max()
BldgSF = pd.concat([BldgSF, BldgSF_zero], axis=1)


# LotSize


LotSize = df.LotSize.copy()
LotSize_zero = (LotSize == "0").apply(int)
LotSize_zero.name = "LotSize_zero"
LotSize = LotSize.str.replace(',','').astype(float)
LotSize = np.log1p(LotSize)
LotSize = LotSize / LotSize.max()
LotSize = pd.concat([LotSize, LotSize_zero], axis=1)


# Style


Style = df.Style.copy()
Style[Style == " "] = np.nan
Style = pd.get_dummies(Style, prefix="Style")


# stories


stories = df.stories.copy()
stories_missing = (stories == 0).apply(int)
stories_missing.name = "stories_missing"
stories[stories == 0] = np.nan
stories = (stories - stories.min()) / (stories.max() - stories.min())
stories = stories.fillna(0)
stories = pd.concat([stories, stories_missing], axis=1)


# STRUCT_FLR


STRUCT_FLR = df.STRUCT_FLR.copy()
STRUCT_FLR_zero = (STRUCT_FLR == 0).apply(int)
STRUCT_FLR_zero.name = "STRUCT_FLR_zero"
STRUCT_FLR = STRUCT_FLR / STRUCT_FLR.max()
STRUCT_FLR = pd.concat([STRUCT_FLR, STRUCT_FLR_zero], axis=1)


# num_units


num_units = df.num_units.copy()
num_units_nonzero = (num_units != 0).apply(int)
num_units_nonzero.name = "num_units_nonzero"
num_units = np.log1p(num_units)
num_units = num_units / num_units.max()
num_units = pd.concat([num_units, num_units_nonzero], axis=1)


# LIV_UNITS


LIV_UNITS = df.LIV_UNITS.copy()
LIV_UNITS_nonzero = (LIV_UNITS != 0).apply(int)
LIV_UNITS_nonzero.name = "LIV_UNITS_nonzero"
LIV_UNITS = np.log1p(LIV_UNITS)
LIV_UNITS = LIV_UNITS / LIV_UNITS.max()
LIV_UNITS = pd.concat([LIV_UNITS, LIV_UNITS_nonzero], axis=1)


# UNIT_NUM


UNIT_NUM = df.UNIT_NUM.copy()
UNIT_NUM_missing = (UNIT_NUM == " ").apply(int)
UNIT_NUM_missing.name = "UNIT_NUM_nonzero"
UNIT_NUM[UNIT_NUM == " "] = "0"
UNIT_NUM = UNIT_NUM.astype(float)
UNIT_NUM = np.log1p(UNIT_NUM)
UNIT_NUM = UNIT_NUM / UNIT_NUM.max()
UNIT_NUM = pd.concat([UNIT_NUM, UNIT_NUM_missing], axis=1)


# construct_


construct_ = df.construct_.copy()
construct_[construct_ == ' '] = np.nan
construct_ = pd.get_dummies(construct_, prefix="construct_")


# Sprinklers


Sprinklers = df.Sprinklers.copy()
Sprinklers[Sprinklers == ' '] = np.nan
Sprinklers = pd.get_dummies(Sprinklers, prefix="Sprinklers")


# Star_Ratin


Star_Ratin = df.Star_Ratin.copy()
Star_Ratin[Star_Ratin == ' '] = "0"
Star_Ratin = Star_Ratin.str.replace(' Star','').astype(int)
Star_Ratin[Star_Ratin == 0] = Star_Ratin.median()


# Market_Seg


Market_Seg = df.Market_Seg.copy()
Market_Seg[Market_Seg == ' '] = np.nan
Market_Seg = pd.get_dummies(Market_Seg, prefix="Market_Seg")


# Bedrooms


Bedrooms = df.Bedrooms.copy()
Bedrooms_nonzero = (Bedrooms != 0).apply(int)
Bedrooms_nonzero.name = "Bedrooms_nonzero"
Bedrooms = Bedrooms / Bedrooms.max()
Bedrooms = pd.concat([Bedrooms, Bedrooms_nonzero], axis=1)


# Bathrooms


Bathrooms = df.Bathrooms.copy()
Bathrooms_nonzero = (Bathrooms != 0).apply(int)
Bathrooms_nonzero.name = "Bathrooms_nonzero"
Bathrooms = Bathrooms / Bathrooms.max()
Bathrooms = pd.concat([Bathrooms, Bathrooms_nonzero], axis=1)


# Owner_Name


threshold = 8
Owner_Name = df.Owner_Name.copy()

# some names include Owner_Name at the beginning, so take a substring
for i, name in enumerate(Owner_Name):
    Owner_Name[i] = name[0:11]

# count the number of properties for each owner
from collections import Counter
counter = Counter(Owner_Name)

# remove all the owners that own less than threshold properties
for i, name in enumerate(Owner_Name):
    if counter[name] < threshold:
        Owner_Name[i] = np.nan
Owner_Name = pd.get_dummies(Owner_Name, prefix="Owner_Name")        


# owner_distance


owner_distance = df.owner_distance.copy()
owner_distance_na = owner_distance.isnull().apply(int)
owner_distance_na.name = "owner_distance_na"
owner_distance = np.log1p(owner_distance)
owner_distance = owner_distance.fillna(0)
owner_distance = owner_distance / owner_distance.max()
owner_distance = pd.concat([owner_distance, owner_distance_na], axis=1)


# owner_public


owner_public = df.owner_public.copy()


# huden10


huden10 = df.huden10.copy()
huden10 = (huden10 - huden10.min()) / (huden10.max() - huden10.min())


# empden10


empden10 = df.empden10.copy()
empden10 = (empden10 - empden10.min()) / (empden10.max() - empden10.min())


# entro10


entro10 = df.entro10.copy()
entro10 = (entro10 - entro10.min()) / (entro10.max() - entro10.min())


# foursqmi10


foursqmi10 = df.foursqmi10.copy()
foursqmi10 = (foursqmi10 - foursqmi10.min()) / (foursqmi10.max() - foursqmi10.min())


# ViolentCrime_Den


ViolentCrime_Den = df.ViolentCrime_Den.copy()
ViolentCrime_Den = (ViolentCrime_Den - ViolentCrime_Den.min()) / (ViolentCrime_Den.max() - ViolentCrime_Den.min())


# PropertyCrime_Den


PropertyCrime_Den = df.PropertyCrime_Den.copy()
PropertyCrime_Den = (PropertyCrime_Den - PropertyCrime_Den.min()) / (PropertyCrime_Den.max() - PropertyCrime_Den.min())


# Pct_white


Pct_white = df.Pct_white.copy()
Pct_white_na = Pct_white.isnull().apply(int)
Pct_white_na.name = "Pct_white_na"
Pct_white = Pct_white.fillna(0)
Pct_white = pd.concat([Pct_white, Pct_white_na], axis=1)


# pct_blk


pct_blk = df.pct_blk.copy()
pct_blk = pct_blk.fillna(0)


# Inspection


Inspection = df.Inspection.copy()
Inspection = (Inspection>0).apply(int)

# Multiple_A


Multiple_A = df.Multiple_A.copy()


# combine the features


feature_list = [
NPU,
SiteZip,
Submarket1,
TAX_DISTR,
NBHD,
ZONING_NUM,
building_c,
PROP_CLASS,
Existing_p,
PropertyTy,
secondaryT,
LUC,
Taxes_Per_,
Taxes_Tota,
TOT_APPR,
VAL_ACRES,
For_Sale_P,
Last_Sale1,
yearbuilt,
year_reno,
Lot_Condition,
Structure_Condition,
Sidewalks,
Multiple_Violations,
Vacancy_pc,
Total_Avai,
Percent_Le,
LandArea_a,
totalbuild,
avg_sf,
Floorsize,
BldgSF,
LotSize,
Style,
stories,
STRUCT_FLR,
num_units,
LIV_UNITS,
UNIT_NUM,
construct_,
Sprinklers,
Star_Ratin,
Market_Seg,
Bedrooms,
Bathrooms,
Owner_Name,
owner_distance,
owner_public,
huden10,
empden10,
entro10,
foursqmi10,
ViolentCrime_Den,
PropertyCrime_Den,
Pct_white,
pct_blk,
Inspection,
Multiple_A    
]

feature_df = pd.concat(feature_list, axis=1)


# label

train_label = (df.previous>0).apply(int)
test_label = (df.lastest_fire > 0).apply(int)

# Save the training and testing datasets in LibSVM format
    
dump_svmlight_file(feature_df, train_label, "train.csv", zero_based=False)
dump_svmlight_file(feature_df, test_label, "test.csv", zero_based=False)

