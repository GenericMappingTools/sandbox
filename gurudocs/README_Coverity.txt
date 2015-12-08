# Instructions to prepare and submit a Coverity analysis at
https://scan.coverity.com/download?tab=cxx

# Quick summary for MSVC builds

# Add the coverity bin dir to the path.
set path=%path%;V:\cov-analysis-win64-7.7.0.4\bin

# Build under the coverity to create the build report
cov-build --dir cov-int nmake

# Archive and compress the result
tar caf GMT.xz cov-int

# Submit the build at
https://scan.coverity.com/projects/gmt?tab=overview

