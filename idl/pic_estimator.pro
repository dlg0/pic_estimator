pro pic_estimator

_c = 3e8
_e = 1.6d-19
_mi	= 1.67262158d-27
_me_mi = 0.000544617
_e0 = 8.8541878e-12 

; Estimate the computational resources required for PIC simulations

; Real time to run for

t = 1e-6

; Physical scale size [m]

xL = 0.1 
yL = 0.1
zL = 0.1

; Particles per cell

ppc = 500

; Particles pushed per second

ppps_gpu = 800e6 ; single cuda K20X
ppps_cpu = 50e6/16.0 ; single AMD Opteron

; n processing units

ncores = 299008.0 ; titan
ngpus = 18688.0 ; titan
cpusPerNode = 16

ppps_total_cpu = ppps_cpu * ncores 
ppps_total_gpu = ppps_gpu * ngpus

; Temperature (required to calculate the Debye length size)

T_keV = 0.05

; Species

;amu = 1.0 ; ions
amu = _me_mi ; electrons

Z = -1.0

; Density

n_m3 = 1e17
n_20 = n_m3/10d0^20

debyeLength = 2.35e-5*sqrt(T_keV/n_20)

nX = xL / debyeLength
nY = yL / debyeLength
nZ = zL / debyeLength

nCells = nX * nY * nZ
nP = ppc * nCells

; Courant condition

courantNumber = 0.8
dt = courantNumber * debyeLength / _c

nT = t / dt

; Plasma frequency

wp = sqrt(n_m3 * (Z * _e)^2 / (amu * _mi * _e0))

; Speed-up using a semi-implicit ES field solver

si_fac = 28

; Total compute time reqd

wallClockTime_sec_cpu = np/ppps_total_cpu*nT
wallClockTime_hr_cpu = wallClockTime_sec_cpu / 3600.0
wallClockTime_dy_cpu = wallClockTime_hr_cpu / 24
wallClockTime_yr_cpu = wallClockTime_dy_cpu / 356

wallClockTime_sec_gpu = np/ppps_total_gpu*nT
wallClockTime_hr_gpu = wallClockTime_sec_gpu / 3600.0
wallClockTime_dy_gpu = wallClockTime_hr_gpu / 24
wallClockTime_yr_gpu = wallClockTime_dy_gpu / 356

wallClockTime_sec_cpu = np/ppps_total_cpu*nT
wallClockTime_hr_cpu = wallClockTime_sec_cpu / 3600.0
wallClockTime_dy_cpu = wallClockTime_hr_cpu / 24
wallClockTime_yr_cpu = wallClockTime_dy_cpu / 356

wallClockTime_sec_gpu = np/ppps_total_gpu*nT
wallClockTime_hr_gpu = wallClockTime_sec_gpu / 3600.0
wallClockTime_dy_gpu = wallClockTime_hr_gpu / 24
wallClockTime_yr_gpu = wallClockTime_dy_gpu / 356


print, 'n time steps: ', nT
print, 'n cells: ', nCells
print, 'n particles: ', nP
print, 'dt: ', dt
print, 'T_keV: ', T_keV
print, 'n_m3: ', n_m3
print, 'debye length: ', debyeLength
print, 'plasma freq [rad/s]: ', wp
print, 'n dt per wp period: ', 1/(wp)/dt
print, ''
print, 'Explicit (CFL) CPU'
print, '------------------'
print, 'Total hours [Millions]: ', wallClockTime_hr_cpu * ncores / 1e6
print, 'Wall clock hours [cpu]: ', wallClockTime_hr_cpu
print, 'Wall clock days [cpu]: ', wallClockTime_dy_cpu
print, 'Wall clock years [cpu]: ', wallClockTime_yr_cpu
print, ''
print, 'Explicit (CFL) GPU'
print, '------------------'
print, 'Total hours [Millions]: ', wallClockTime_hr_gpu * ngpus / 1e6 * cpusPerNode
print, 'Wall clock hours [gpu]: ', wallClockTime_hr_gpu
print, 'Wall clock days [gpu]: ', wallClockTime_dy_gpu
print, 'Wall clock years [gpu]: ', wallClockTime_yr_gpu
print, ''
print, 'Semi-implicit (ES) (CFL) CPU'
print, '----------------------------'
print, 'Total hours [Millions]: ', wallClockTime_hr_cpu/si_fac * ncores / 1e6
print, 'Wall clock hours [cpu]: ', wallClockTime_hr_cpu/si_fac
print, 'Wall clock days [cpu]: ',  wallClockTime_dy_cpu/si_fac
print, 'Wall clock years [cpu]: ', wallClockTime_yr_cpu/si_fac
print, ''                                              
print, 'Semi-implicit (ES) (CFL) GPU'                  
print, '------------------'                            
print, 'Total hours [Millions]: ', wallClockTime_hr_gpu/si_fac * ngpus / 1e6 * cpusPerNode
print, 'Wall clock hours [gpu]: ', wallClockTime_hr_gpu/si_fac
print, 'Wall clock days [gpu]: ',  wallClockTime_dy_gpu/si_fac
print, 'Wall clock years [gpu]: ', wallClockTime_yr_gpu/si_fac






stop
end
