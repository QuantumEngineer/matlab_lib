%current_dir = cd
cd 'C:\Users\kahn\OneDrive\UCB\Research\Zettl Group\Projects\2020 BZ\Data\ALGRBN01_100K_30keV_hole_doped' 
file = filesearch('exp1222')
data = transportdata(file,0.00005,15,'s')
