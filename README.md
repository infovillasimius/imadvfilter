# imadvfilter2

Adaptive Local Noise Reduction Filter (adaptive filter for local noise reduction) is based on the formula:

f (x, y) = g (x, y) -vR / vL (g (x, y) -mL) with vR = noise variance, vL = local variance, mL = local average

in which the ratio, between the variance of the Gaussian additive noise in the image and the local variance of the area around the application point, establishes the amount by which the value of each point of the image is modified.

As noise variance grows, we can see how the result changes in relation to the size of the filter. For small values it perfectly respects the details but fails to clean up the large areas without details and the image appears mottled.

If we increase the size, the large areas are much more uniform and the details are not blurred but, in the vicinity and at these noise is not eliminated, leaving these areas virtually unaltered.

To improve the performance of the adaptive filter, by eliminating these problems a new algorithm has been developed that adds to the basic one the advantage of operating, when necessary, with a smaller window, near and in the presence of those small details that, by doing increasing the local variance increases the ratio with the noise variance, beyond a certain threshold (supplied to the filter as an argument).

If the ratio between the variances exceeds this threshold, the algorithm tries to check whether by decreasing the filter size, for that point, the ratio drops back below the threshold and, in this case, applies the basic formula. Otherwise the filter dimensions will continue to decrease until the minimum size (3x3) is reached. It then proceeds to check the value of the ratio of the variances and, if it is greater than 1, always applies the basic formula, replacing, otherwise, the value of the current pixel with the average of the 3x3 around it.

The results obtained with the described procedure are remarkable in terms of image cleanliness and respect for details.

In order to quantify the results obtainable from the implemented filter, with respect to the basic one, we proceeded to carry out tests with various images (cameraman.tif, lenaBW.tif, x-ray.tif) widely used and known, verifying, for each test, the average quadratic error obtained by comparing the original image with the cleaned one.

The tests were carried out on the three images, added with increasing variance noise from 0.001 to 0.010, and with a filter size from 3x3 to 15x15.

From the observation of the data and the graphs obtained we can deduce that the advanced local adaptive filter produces better results (lower average quadratic error) on all the images tested, with respect to the already excellent local adaptive filter, especially as the variance of the added noise increases.

Furthermore, for each image there is an optimal value for the filter size, linked to the size of the details.

On the other hand, considering that in the added part of the function, performed recursively, the size of the application window is halved at each step, the complexity of the algorithm increases in the worst case (vl / vR> d for all pixels and for any size of the 'around) of a logarithmic factor log m, with m size of the filter.

Experimental data on execution times, obtained with the MatLab profiler, confirm this statement.

Use: imadfilter2(Image,size,noise_variance,treshold)
