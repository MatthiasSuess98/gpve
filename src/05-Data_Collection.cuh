#ifndef GCPVE_04_DATA_COLLECTION_CUH
#define GCPVE_04_DATA_COLLECTION_CUH

typedef struct SmallDataCollection {
    // small = 16 bit
    unsigned float mulp[65536];
    unsigned float warp[65536];
    unsigned float lane[65536];
    unsigned float time[65536];
} SmallDataCollection;

typedef struct MediumDataCollection {
    // medium = 24 bit
    unsigned float mulp[16777216];
    unsigned float warp[16777216];
    unsigned float lane[16777216];
    unsigned float time[16777216];
} MediumDataCollection;

typedef struct LargeDataCollection {
    // large = 32 bit
    unsigned float mulp[4294967296];
    unsigned float warp[4294967296];
    unsigned float lane[4294967296];
    unsigned float time[4294967296];
} LargeDataCollection;

#endif //GCPVE_04_DATA_COLLECTION_CUH

