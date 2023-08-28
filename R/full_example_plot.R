# install.packages("ggplot2") # if you haven't installed ggplot yet, uncomment and run this line.

library(ggplot2) # load the ggplot library. 

crab_width <- read.csv('./data/LTER_CrabCarapaces.csv') # read in the crab carapace lengths

# we can get a look at the crab carapace data with a few commands:

View(crab_width) # this will open up a new tab to see all data
str(crab_width) # view the structure of the data frame
head(crab_width) # View just the top 10 rows

# There is a million ways to do this.


# option 1: Base R

# create summary table. There's a millions ways to do this. I'll do a messy but simple way.

mean_BC <- mean(crab_width$carapace_width[which(crab_width$Site == 'BC')]) # take mean of BC
sd_BC <- sd(crab_width$carapace_width[which(crab_width$Site == 'BC')]) # take sd of BC

# same for GTM
mean_GTM <- mean(crab_width$carapace_width[which(crab_width$Site == 'GTM')])
sd_GTM <- sd(crab_width$carapace_width[which(crab_width$Site == 'GTM')])

crab_means <- data.frame(Site = c('BC','GTM'),
                        mean = c(mean_BC, mean_GTM),
                        sd = c(sd_BC, sd_GTM))


# Option 2: dplyr

library(dplyr) # install it if you haven't already

# create a dataframe of summary variables

crab_means <- crab_width |> 
  filter(Site %in% c('GTM','BC')) |> 
  group_by(Site) |> 
  summarise(mean = mean(carapace_width),
            sd = sd(carapace_width))


# plot it:

# this is a basic ugly plot:
ggplot(data = crab_means) +
  geom_bar(aes(x = Site, y = mean), stat = 'identity') + 
  geom_errorbar(aes(x = Site, ymin = mean, ymax = mean + sd))

# We can make it more pretty

ggplot(data = crab_means) +
  geom_bar(aes(x = Site, y = mean), stat = 'identity') + 
  geom_errorbar(aes(x = Site, ymin = mean, ymax = mean + sd)) +
  labs(x = 'Site', y = 'Mean Carapace Width [mm]')+
  theme_classic()


ggplot(data = crab_means) +
  geom_bar(aes(x = Site, y = mean, fill = Site), stat = 'identity') + 
  geom_errorbar(aes(x = Site, ymin = mean, ymax = mean + sd, color = Site),
                width = 0.5) +
  labs(x = 'Site', y = 'Mean Carapace Width [mm]')+
  theme_classic()


ggplot(data = crab_means) +
  geom_bar(aes(x = Site, y = mean, fill = Site), stat = 'identity') + 
  geom_errorbar(aes(x = Site, ymin = mean, ymax = mean + sd, color = Site),
                width = 0.5) +
  scale_y_continuous(expand = c(0,0))+
  scale_fill_manual(values = c('black', 'grey'))+
  scale_color_manual(values = c('black', 'grey'))+
  labs(x = 'Site', y = 'Mean Carapace Width [mm]')+
  theme_classic() +
  theme(legend.position = 'none', axis.title = element_text(face = 'bold'))
