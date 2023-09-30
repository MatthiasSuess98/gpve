#ifndef GCPVE_C_C_2_BENCHMARK_PROPERTIES_CUH
#define GCPVE_C_C_2_BENCHMARK_PROPERTIES_CUH

/**
 * Data structure for all properties of the benchmark.
 */
typedef struct BenchmarkProperties {

    // Variables.
    int numberOfTrialsPerform;
    int numberOfTrialsLaunch;
    int numberOfTrialsBenchmark;
    int collectionFactor;
    long double maxDelta;
    int maxDontFit;
} BenchmarkProperties;


/**
 * Creates a data structure with all properties of the benchmark.
 * @return Data structure with all properties of the benchmark.
 */
BenchmarkProperties getBenchmarkProperties() {

    // Create the final data structure.
    BenchmarkProperties prop;

    // Initialize the properties and writes them into the final data structure.
    prop.numberOfTrialsPerform = 10;
    prop.numberOfTrialsLaunch = 10;
    prop.numberOfTrialsBenchmark = 1024;
    prop.collectionFactor = 16;
    prop.maxDelta = 3.0;
    prop.maxDontFit = 3;

    // Return the final data structure.
    return prop;
}


/**
 * Creates a csv file with all information of the given data structure.
 * @param prop The given data structure.
 */
void createPropFile(BenchmarkProperties prop) {

    // Creation and opening of the csv file.
    char output[] = "raw/Bench_Prop.csv";
    FILE *csv = fopen(output, "w");

    // Writing all the information into the csv file.
    fprintf(csv, "numberOfTrialsPerform;\"%d\"\n", prop.numberOfTrialsPerform);
    fprintf(csv, "numberOfTrialsLaunch;\"%d\"\n", prop.numberOfTrialsLaunch);
    fprintf(csv, "numberOfTrialsBenchmark;\"%d\"\n", prop.numberOfTrialsBenchmark);
    fprintf(csv, "collectionFactor;\"%d\"\n", prop.collectionFactor);
    fprintf(csv, "maxDelta;\"%Lf\"\n", prop.maxDelta);
    fprintf(csv, "maxDontFit;\"%d\"\n", prop.maxDontFit);

    // Close the csv file.
    fclose(csv);
    printf("[INFO] The benchmark properties file was created.\n");
}

#endif //GCPVE_C_C_2_BENCHMARK_PROPERTIES_CUH

//FINISHED

