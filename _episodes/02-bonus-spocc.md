---
title: "Bonus: using `spocc` to query many biodiversity data stores at once"
teaching: 10
exercises: 0
questions:
objectives:
keypoints:
---

#### Bonus: querying many data systems using `spocc`


Using spocc, we can search OBIS, GBIF, ALA, and other data systems at once!

ROpenSci split spocc into three packages, now it's spocc -> scrubr -> mapr to get all the way to a map from searching occurrences 

~~~
# install.packages('spocc')
library(spocc)
# scrubr
# we won't use this today but can confirm we've installed it
# install.packages('scrubr')
library(scrubr)
# mapr
# install.packages('mapr')
library(mapr)
~~~
{: .language-r}

Once you have these, it's literally as easy as:

~~~
#1: make a vector of species you care about
spp <- c('Danaus plexippus','Accipiter striatus','Pinus contorta')
#2: ask some or all of the biodiversity databases what records they have
dat <- occ(query = spp, from = 'gbif', has_coords = TRUE, limit = 100)

#3: Map your results:
mapr::map_leaflet(dat)
~~~
{: .language-r}


~~~
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
~~~
{: .language-r}


##### Which datasets are providing my data?
~~~
dat$obis$data$salmonidae$dataset_id %>% unique()
~~~
{: .language-r}

##### https://obis.org/dataset/[dataset_id]

Visit the homepages for these datasets by appending their UUID to the OBIS dataset URL e.g. https://obis.org/dataset/18e4fa5b-5f92-4e09-957b-b242003287e9

A lot of the values in these Occurrences are DarwinCore terms coming as they do from DarwinCore Archives: https://dwc.tdwg.org/terms/

~~~
# can check for presence/absence records:
dat$obis$data$salmonidae$occurrenceStatus

# And there's very often information about who recorded the observations:
dat$obis$data$salmonidae$recordedBy %>% unique()
~~~
{: .language-r}


{% include links.md %}

