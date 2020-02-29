# Gravitational Space Golf

* Place planets to have their gravity guide a golf ball to its goal.

* Planets could have different size / mass, which players could change.

* Have a limit on…
  * …the number of planets we can place
  * …the total mass of all planets we can place
  * …both
  
* Be able to preview the path the ball will take
  * Continually
  * A limited number of times
  * Not at all
  
* Force excerted on the ball by planet $i$:

  $$
  f_{i} = \frac{g*m_i}{d_{i} \cdot \sqrt{d_{i} + s}}
  $$

  With:

  | Symbol | Description                          |
  | ------ | ------------------------------------ |
  | $g$    | Gravitational constant               |
  | $m_i$  | Mass of planet $i$                   |
  | $d_i$  | Distance between ball and planet $i$ |
  | $s$    | Dampening                            |

