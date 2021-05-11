# Using robis (and spocc) to pull species occurrences from the OBIS data system (and others!)
# adapted from course materials from 2020's OBIS Canada training 
# see https://github.com/OBISCanada/obis-workshop

# Using robis to search for occurrences of a species  -----

library(tidyverse)
library(robis)


# Query OBIS for occurrence data:
# ?robis::occurrence
pbgl_df <- robis::occurrence('Lamna nasus')

View(pbgl_df)

# Query OBIS for occurrence data, but using the AphiaID of a taxon.
taxid <- robis::occurrence(taxonid=105841)


# Selecting records within a geographic polygon: -----

# can make polygon notation (Well-Known Text) at https://obis.org/maptool/# 
# or using any other WKT generator

# NOTE: OBIS has a lot of records! A larger geometric range without any other filters
# can return millions of results! 
# For designing and retrieving larger datasets, try https://mapper.obis.org

# Search in a box around the Atlantic and the GoSL:
gosl_df <- robis::occurrence('salmonidae', geometry = "POLYGON ((-59.85352 46.25585, 
                                                    -66.79688 43.51669, 
                                                    -65.83008 38.54817, 
                                                    -49.65820 38.54817, 
                                                    -48.42773 46.61926, 
                                                    -56.16211 54.16243, 
                                                    -71.45508 47.21957, 
                                                    -59.85352 46.25585))")

robis::map_leaflet(gosl_df)

# Default map popup isn't very useful to explore with, let's make a bit of HTML:
robis::map_leaflet(gosl_df, 
            popup= function(x) {paste0('<a href="https://obis.org/dataset/', x['dataset_id'], '">',x['dataset_id'],'</a><br />', 
                                       x['recordedBy'])}
            )
            
# Applying other kinds of filters: -----

# Depth
roughy_shallow <- robis::occurrence("Hoplostethus atlanticus", enddepth=400)
robis::map_leaflet(roughy_shallow)

# Date
lionfish_native <- robis::occurrence("Pterois volitans", enddate="1980-01-01")
robis::map_leaflet(lionfish_native)

lionfish_now <- robis::occurrence("Pterois volitans")
robis::map_leaflet(lionfish_now)

# Inside your robis occurrence dataframe:
names(gosl_df)

# These terms are all Darwin Core terms and definitions can be found at 
# https://dwc.tdwg.org/terms/

# A general idea of the results and the years they were observed
table(gosl_df$year)


# MeasurementsOrFacts: -----
# are related back to occurrence records via the occurrenceID
# for datasets that have Events, can find more data connected via EventID
# i.e. when a sampling cruise also does CTD casting, ocean chemistry, etc.

# furrow-shell mollusc
occ_w_mof <- robis::occurrence('Abra tenuis', mof=TRUE)

# get associated measurements to these occurrence records, keeping the fields
# specified in 'fields'
mof <- robis::measurements(occ_w_mof, fields=c('scientificName', 
                                               'decimalLongitude', 
                                               'decimalLatitude', 
                                               'eventDate'))

View(mof)

# What are some of the measurement or facts that OBIS tracks?
# see a full report and search for terms at https://mof.obis.org/
# 7.2m records of fish length!
# 3.3m records of sampling protocol

# Human-readable mof columns for our dataset:
mof %>% select('eventDate', 'decimalLongitude', 'decimalLatitude', 'measurementType', 'measurementValue') %>% View

# What if we need a specific type of measurement?

mof$measurementTypeID %>% unique()

# MeasurementTypeIDs are URIs, which is handy, because we can
# visit e.g. http://vocab.nerc.ac.uk/collection/P01/current/OBSINDLX/
# to see a definition of the measurement.

# MOF - Observed Length: 
# Let's grab some length data
mof %>% filter(measurementTypeID == 'http://vocab.nerc.ac.uk/collection/P01/current/OBSINDLX/') %>% View

# The ability to use vocabulary services to record definitively how things are measured
# improves the capacity for others to be able to reuse the data collected.
# OBIS monitors the completeness of these records and works with nodes to 
# continually improve them



# Assignment - exploring deep-water corals in OBIS -----

# On the deep-water coral page on Wikipedia we read this:
  
# The habitat of deep-water corals, also known as cold-water corals, 
# extends to deeper, darker parts of the oceans than tropical corals, 
# ranging from near the surface to the abyss, beyond 2,000 metres where 
# water temperatures may be as cold as 4 °C. Deep-water corals belong to the 
# Phylum Cnidaria and are most often stony corals (Scleractinia), but also 
# include black and horny corals (Antipatharia) and soft corals (Alcyonacea) 
# including the Gorgonians.

# ************************
# **For this assignment:**
# ************************

#  Use robis to retrieve deep-water coral occurrences below 2000 m from OBIS

#                and 

#  Find how the occurrences are distributed among the different orders





# BONUS CONTENT: spocc ----------------------------

# Using spocc, we can search OBIS, GBIF, ALA, and other data systems at once! -----

# ROpenSci split spocc into three packages, 
# now it's spocc -> scrubr -> mapr to get all the way to a map from 
# searching occurrences 

# install.packages('spocc')
library(spocc)
# scrubr
# we won't use this today but can confirm we've installed it
# install.packages('scrubr')
library(scrubr)
# mapr
# install.packages('mapr')
library(mapr)

# Once you have these, it's literally as easy as:

#1: make a vector of species you care about
spp <- c('Danaus plexippus','Accipiter striatus','Pinus contorta')
#2: ask some or all of the biodiversity databases what records they have
dat <- occ(query = spp, from = 'gbif', has_coords = TRUE, limit = 100)

#3: Map your results:
mapr::map_leaflet(dat)


# 1: Try your own favourite query:
here_fishy_fishy <- c('salmonidae')

# 2: and ask OBIS Canada for results!
dat <- occ(query = here_fishy_fishy, 
           from = 'obis', # just OBIS results
           obisopts=list(nodeid="7dfb2d90-9317-434d-8d4e-64adf324579a"), # just OBIS Canada
           has_coords = TRUE,   # just entries we can geolocate 
           limit=200)           # just the first 200 pages (200,000 rows) of data

# 3: What do we see?
mapr::map_leaflet(dat)


# Which datasets are providing my data?

dat$obis$data$salmonidae$dataset_id %>% unique()

# https://obis.org/dataset/[dataset_id]

# Visit the homepages for these datasets by appending their UUID to the OBIS dataset URL:
# e.g. https://obis.org/dataset/18e4fa5b-5f92-4e09-957b-b242003287e9

# A lot of the values in these Occurrences are DarwinCore terms
# coming as they do from DarwinCore Archives:
# https://dwc.tdwg.org/terms/

# can check for presence/absence records:
dat$obis$data$salmonidae$occurrenceStatus

# And there's very often information about who recorded the observations:
dat$obis$data$salmonidae$recordedBy %>% unique()

# These datasets are kind of sparse on important information 
# - no dates, no recordedBy?
#

