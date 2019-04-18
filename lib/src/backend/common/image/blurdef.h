// Copyright (c) 2012-2017 VideoStitch SAS
// Copyright (c) 2018 stitchEm

#define COLUMNS_BLOCKDIM_X 16
#define COLUMNS_BLOCKDIM_Y 8
#define COLUMNS_RESULT_STEPS 16
#define COLUMNS_HALO_STEPS 1

#define ROWS_BLOCKDIM_X 16
#define ROWS_BLOCKDIM_Y 4
#define ROWS_RESULT_STEPS 4
#define ROWS_HALO_STEPS 1

#define SIZE_Y ((COLUMNS_RESULT_STEPS + 2 * COLUMNS_HALO_STEPS) * COLUMNS_BLOCKDIM_Y + 1)  // +1 to avoid bank conflicts
#define SIZE_X ((ROWS_RESULT_STEPS + 2 * ROWS_HALO_STEPS) * ROWS_BLOCKDIM_X)

#define KERNEL_RADIUS 2
#define KERNEL_LENGTH (2 * KERNEL_RADIUS + 1)
