#ifndef GCPVE_10_PERFORM_BENCHMARK_CUH
#define GCPVE_10_PERFORM_BENCHMARK_CUH

#include <vector>

#include "01-Gpu_Information.cuh"
#include "02-Benchmark_Properties.cuh"
#include "03-Info_Prop_Derivatives.cuh"
#include "04-Core_Characteristics.cuh"
#include "05-Data_Collection.cuh"
#include "20-L1_Cache_Launcher.cuh"

/**
 * Performs Benchmark 1.
 * @param info All available information of the current GPU.
 * @param prop All properties of the benchmarks.
 * @param derivatives All derivatives of info and prop.
 */
void performBenchmark1(GpuInformation info, BenchmarkProperties prop, InfoPropDerivatives derivatives) {

    // Declare and initialize collection.
    DataCollection data;
    for (int i = 0; i < derivatives.collectionSize; i++) {
        int iniMulp = 0;
        data.mulp.push_back(iniMulp);
        int iniWarp = 0;
        data.warp.push_back(iniWarp);
        int iniLane = 0;
        data.lane.push_back(iniLane);
        long long int iniTime = 0;
        data.time.push_back(iniTime);
    }

    // Declare and initialize all core characteristics.
    std::vector<CoreCharacteristics> gpuCores;
    CoreCharacteristics gpuCore = CoreCharacteristics(0, 0, 0);
    for (int i = 0; i < info.multiProcessorCount; i++) {
        for (int j = 0; j < derivatives.hardwareWarpsPerSm; j++) {
            for (int k = 0; k < info.warpSize; k++) {
                gpuCore = CoreCharacteristics(i, j, k);
                gpuCores.push_back(gpuCore);
            }
        }
    }

    // Perform the benchmark loop.
    int hardwareWarpScore;
    int smallestNumber;
    int bestHardwareWarp;
    long long int currentTime;
    std::vector<int> dontFits;
    int dontFit;
    for (int warpLoop = 0; warpLoop < info.warpSize; warpLoop++) {
        dontFit = 0;
        dontFits.push_back(dontFit);
    }
    for (int trailLoop = 0; trailLoop < prop.numberOfTrialsPerform; trailLoop++) {
        for (int resetLoop = 0; resetLoop < derivatives.collectionSize; resetLoop++) {
            data.mulp[resetLoop] = 0;
            data.warp[resetLoop] = 0;
            data.lane[resetLoop] = 0;
            data.time[resetLoop] = 0;
        }
        data = performL1Benchmark(info, prop, derivatives);
        for (int blockLoop = 0; blockLoop < derivatives.collectionSize; blockLoop = blockLoop + info.warpSize) {
            if (data.time[blockLoop] != 0) {
                hardwareWarpScore = 0;
                for (int hardwareWarpLoop = 0; hardwareWarpLoop < derivatives.hardwareWarpsPerSm; hardwareWarpLoop++) {
                    dontFits[hardwareWarpLoop] = 0;
                }
                for (int hardwareWarpLoop = 0; hardwareWarpLoop < derivatives.hardwareWarpsPerSm; hardwareWarpLoop++) {
                    if (gpuCores[(data.mulp[blockLoop] * derivatives.hardwareWarpsPerSm * info.warpSize) + (hardwareWarpLoop * info.warpSize)].getTypicalL1Time() != 0) {
                        hardwareWarpScore++;
                    }
                }
                if (hardwareWarpScore == 0) {
                    for (int laneLoop = 0; laneLoop < info.warpSize; laneLoop++) {
                        gpuCores[(data.mulp[blockLoop] * derivatives.hardwareWarpsPerSm * info.warpSize) + laneLoop].setTypicalL1Time(data.time[blockLoop + laneLoop]);
                    }
                } else if (hardwareWarpScore == derivatives.hardwareWarpsPerSm) {
                    for (int hardwareWarpLoop = 0; hardwareWarpLoop < derivatives.hardwareWarpsPerSm; hardwareWarpLoop++) {
                        for (int laneLoop = 0; laneLoop < info.warpSize; laneLoop++) {
                            if (std::abs(gpuCores[(data.mulp[blockLoop] * derivatives.hardwareWarpsPerSm * info.warpSize) + (hardwareWarpLoop * info.warpSize) + laneLoop].getTypicalL1Time() - data.time[blockLoop]) >= prop.maxDelta) {
                                dontFits[hardwareWarpLoop]++;
                            }
                        }
                    }
                    smallestNumber = 0;
                    bestHardwareWarp = 0;
                    for (int hardwareWarpLoop = 0; hardwareWarpLoop < derivatives.hardwareWarpsPerSm; hardwareWarpLoop++) {
                        if (hardwareWarpLoop == 0) {
                            smallestNumber = dontFits[hardwareWarpLoop];
                        } else {
                            if (smallestNumber > dontFits[hardwareWarpLoop]) {
                                smallestNumber = dontFits[hardwareWarpLoop];
                            }
                        }
                    }
                    for (int hardwareWarpLoop = 0; hardwareWarpLoop < derivatives.hardwareWarpsPerSm; hardwareWarpLoop++) {
                        if (smallestNumber == dontFits[hardwareWarpLoop]) {
                            bestHardwareWarp = hardwareWarpLoop;
                        }
                    }
                    for (int laneLoop = 0; laneLoop < info.warpSize; laneLoop++) {
                        currentTime = gpuCores[(data.mulp[blockLoop] * derivatives.hardwareWarpsPerSm * info.warpSize) + (bestHardwareWarp * info.warpSize) + laneLoop].getTypicalL1Time();
                        gpuCores[(data.mulp[blockLoop] * derivatives.hardwareWarpsPerSm * info.warpSize) + (bestHardwareWarp * info.warpSize) + laneLoop].setTypicalL1Time((data.time[blockLoop + laneLoop] + currentTime) / 2);
                    }
                } else {
                    for (int hardwareWarpLoop = 0; hardwareWarpLoop < hardwareWarpScore; hardwareWarpLoop++) {
                        for (int laneLoop = 0; laneLoop < info.warpSize; laneLoop++) {
                            if (std::abs(gpuCores[(data.mulp[blockLoop] * derivatives.hardwareWarpsPerSm * info.warpSize) + (hardwareWarpLoop * info.warpSize) + laneLoop].getTypicalL1Time() - data.time[blockLoop]) >= prop.maxDelta) {
                                dontFits[hardwareWarpLoop]++;
                            }
                        }
                    }
                    smallestNumber = 0;
                    bestHardwareWarp = 0;
                    for (int hardwareWarpLoop = 0; hardwareWarpLoop < hardwareWarpScore; hardwareWarpLoop++) {
                        if (hardwareWarpLoop == 0) {
                            smallestNumber = dontFits[hardwareWarpLoop];
                        } else {
                            if (smallestNumber > dontFits[hardwareWarpLoop]) {
                                smallestNumber = dontFits[hardwareWarpLoop];
                            }
                        }
                    }
                    for (int hardwareWarpLoop = 0; hardwareWarpLoop < hardwareWarpScore; hardwareWarpLoop++) {
                        if (smallestNumber == dontFits[hardwareWarpLoop]) {
                            bestHardwareWarp = hardwareWarpLoop;
                        }
                    }
                    if (dontFits[bestHardwareWarp] > prop.maxDontFit) {
                        for (int laneLoop = 0; laneLoop < info.warpSize; laneLoop++) {
                            gpuCores[(data.mulp[blockLoop] * derivatives.hardwareWarpsPerSm * info.warpSize) + (hardwareWarpScore * info.warpSize) + laneLoop].setTypicalL1Time(data.time[blockLoop + laneLoop]);
                        }
                    } else {
                        for (int laneLoop = 0; laneLoop < info.warpSize; laneLoop++) {
                            currentTime = gpuCores[(data.mulp[blockLoop] * derivatives.hardwareWarpsPerSm * info.warpSize) + (bestHardwareWarp * info.warpSize) + laneLoop].getTypicalL1Time();
                            gpuCores[(data.mulp[blockLoop] * derivatives.hardwareWarpsPerSm * info.warpSize) + (bestHardwareWarp * info.warpSize) + laneLoop].setTypicalL1Time((data.time[blockLoop + laneLoop] + currentTime) / 2);
                        }
                    }
                }
            }
        }
    }

    // Create file with all l1 benchmark data.
    char output[] = "Benchmark1_L1.csv";
    FILE *csv = fopen(output, "w");
    for (int i = 0; i < info.multiProcessorCount; i++) {
        for (int j = 0; j < derivatives.hardwareWarpsPerSm; j++) {
            for (int k = 0; k < info.warpSize; k++) {
                fprintf(csv, "%lld", (gpuCores[(i * derivatives.hardwareWarpsPerSm * info.warpSize) + (j * info.warpSize) + k].getTypicalL1Time() / (numberOfTrialsBenchmark * numberOfTrialsBenchmark)));
                if ((k + 1) < info.warpSize) {
                    fprintf(csv, " ; ");
                }
            }
            if ((i + 1) < info.multiProcessorCount) {
                fprintf(csv, "\n");
            }
        }
        if ((i + 1) < info.multiProcessorCount) {
            fprintf(csv, "\n");
        }
    }
    fclose(csv);
    printf("[INFO] L1 Benchmark file created.\n");
}

#endif //GCPVE_10_PERFORM_BENCHMARK_CUH

//FINISHED

