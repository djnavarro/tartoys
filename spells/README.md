
# spells

``` r
library(targets)
tar_manifest()
#> # A tibble: 8 × 2
#>   name           command                                                  
#>   <chr>          <chr>                                                    
#> 1 input          "\"spells.csv\""                                         
#> 2 output         "set_output_dir()"                                       
#> 3 spells         "read_csv(input, show_col_types = FALSE)"                
#> 4 scholastic_dat "scholastic_make(spells)"                                
#> 5 dice_dat       "dice_make(spells)"                                      
#> 6 scholastic_mat "scholastic_dist(scholastic_dat)"                        
#> 7 dice_pic       "dice_plot(dice_dat, output)"                            
#> 8 scholastic_pic "scholastic_plot(scholastic_dat, scholastic_mat, output)"
```

Status:

``` r
tar_outdated()
#> [1] "scholastic_dat" "scholastic_mat" "spells"         "scholastic_pic"
#> [5] "output"         "dice_pic"       "input"          "dice_dat"
```

Run once:

``` r
tar_make()
#> ▶ dispatched target input
#> ● completed target input [0.282 seconds, 302.514 kilobytes]
#> ▶ dispatched target output
#> ● completed target output [0.002 seconds, 144 bytes]
#> ▶ dispatched target spells
#> ● completed target spells [0.085 seconds, 73.966 kilobytes]
#> ▶ dispatched target scholastic_dat
#> ● completed target scholastic_dat [0.02 seconds, 401 bytes]
#> ▶ dispatched target dice_dat
#> ● completed target dice_dat [0.017 seconds, 33.486 kilobytes]
#> ▶ dispatched target scholastic_mat
#> ● completed target scholastic_mat [0.048 seconds, 310 bytes]
#> ▶ dispatched target dice_pic
#> ● completed target dice_pic [0.848 seconds, 153 bytes]
#> ▶ dispatched target scholastic_pic
#> ● completed target scholastic_pic [0.208 seconds, 156 bytes]
#> ▶ ended pipeline [1.605 seconds]
```

Check status again:

``` r
tar_outdated()
#> character(0)
```

Run again:

``` r
tar_make()
#> ✔ skipped target input
#> ✔ skipped target output
#> ✔ skipped target spells
#> ✔ skipped target scholastic_dat
#> ✔ skipped target dice_dat
#> ✔ skipped target scholastic_mat
#> ✔ skipped target dice_pic
#> ✔ skipped target scholastic_pic
#> ✔ skipped pipeline [0.078 seconds]
```

Load target object:

``` r
tar_load("dice_dat")
dice_dat
#> # A tibble: 236 × 8
#>    name           level description dice_txt position dice_num dice_die dice_val
#>    <chr>          <dbl> <chr>       <fct>       <int>    <dbl>    <dbl>    <dbl>
#>  1 Acid Splash        0 "You creat… 1d6             1        1        6      3.5
#>  2 Acid Splash        0 "You creat… 2d6             2        2        6      7  
#>  3 Acid Splash        0 "You creat… 3d6             3        3        6     10.5
#>  4 Acid Splash        0 "You creat… 4d6             4        4        6     14  
#>  5 Alter Self         2 "You alter… 1d6             1        1        6      3.5
#>  6 Animate Objec…     5 "Objects a… 1d4             1        1        4      2.5
#>  7 Animate Objec…     5 "Objects a… 1d6             2        1        6      3.5
#>  8 Animate Objec…     5 "Objects a… 1d12            3        1       12      6.5
#>  9 Animate Objec…     5 "Objects a… 2d6             4        2        6      7  
#> 10 Animate Objec…     5 "Objects a… 2d12            5        2       12     13  
#> # ℹ 226 more rows
```
