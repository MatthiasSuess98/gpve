#ifndef GCPVE_03_CORE_CHARACTERISTICS_CUH
#define GCPVE_03_CORE_CHARACTERISTICS_CUH

class CoreCharacteristics {
private:
    unsigned int smId;
    unsigned int hardwareWarpId;
    unsigned int warpCoreId;
    unsigned float typicalL1Time;
    unsigned float typicalSmTime;
    unsigned float typicalL2Time;
    unsigned float typicalGmTime;

public:
    CoreCharacteristics(unsigned int newSmId, unsigned int newHardwareWarpId, unsigned int newWarpCoreId) {
        smId = newSmId;
        hardwareWarpId = newHardwareWarpId;
        warpCoreId = newWarpCoreId;
        typicalL1Time = 0;
        typicalSmTime = 0;
        typicalL2Time = 0;
        typicalGmTime = 0;
    }

    setTypicalL1Time(unsigned float newTypicalL1Time) {
        typicalL1Time = newTypicalL1Time;
    }

    setTypicalSmTime(unsigned float newTypicalSmTime) {
        typicalSmTime = newTypicalSmTime;
    }

    setTypicalL2Time(unsigned float newTypicalL2Time) {
        typicalL2Time = newTypicalL2Time;
    }

    setTypicalGmTime(unsigned float newTypicalGmTime) {
        typicalGmTime = newTypicalGmTime;
    }

    unsigned int getSmId() {
        return smId;
    }

    unsigned int getHardwareWarpId() {
        return hardwareWarpId;
    }

    unsigned int getWarpCoreId() {
        return warpCoreId;
    }

    unsigned float getTypicalL1Time() {
        return typicalL1Time;
    }

    unsigned float getTypicalSmTime() {
        return typicalSmTime;
    }

    unsigned float getTypicalL2Time() {
        return typicalL2Time;
    }

    unsigned float getTypicalGmTime() {
        return typicalGmTime;
    }
};

#endif //GCPVE_03_CORE_CHARACTERISTICS_CUH

