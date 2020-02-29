# Gravitational Plane Crash

# Variables
A: wing-area
c_l: lift-coefficient (experimentally)
c_d: drag-coefficient (experimentally)
rho: density
v: velocity
m: mass
g: 9.81


## Forces
### Lift force
F_L = 0.5 * c_l * rho * v^2 * A

 * perpendicular to plane wings

### Drag force
F_D = 0.5 * c_d * rho * v^2 * A

 * parallel to plane


### Weight force
F_W = m*g


## Equations of motion

y: L * cos(alpha) + D * sin(alpha) - W = 0
x: L * sin(alpha) - D * cos(alpha)     = 0


# velocities
v_x = sqrt(2g*(m/a)/rho * c_l)
v_y = c_d * sqrt(2g*(m/a)/rho * c_l)