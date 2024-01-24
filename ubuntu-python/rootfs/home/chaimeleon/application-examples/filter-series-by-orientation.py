import sys
import os
import json
from enum import Enum
import pydicom, pydicom.multival
import numpy as np

IMAGE_ORIENTATION_PATIENT_TAG = 0x0020, 0x0037

class Orientation(Enum):
    X_TRANSVERSE = 1 # AXIAL
    Y_CORONAL = 2    # FRONTAL
    Z_SAGITTAL = 3   # LATERAL
    UNDEFINED = 99

def extract_orientation(image_orientation: pydicom.multival.MultiValue):
    orientation = Orientation.UNDEFINED
    if image_orientation is not np.nan:
        row_cosines = np.array((image_orientation[0], image_orientation[1], image_orientation[2]), 'float32')
        col_cosines = np.array((image_orientation[3], image_orientation[4], image_orientation[5]), 'float32')
        cross_product = np.abs(np.cross(row_cosines, col_cosines))
        max = np.max(cross_product)

        if cross_product[0] == max:
            orientation = Orientation.X_TRANSVERSE
        elif cross_product[1] == max:
            orientation = Orientation.Y_CORONAL
        elif cross_product[2] == max:
            orientation = Orientation.Z_SAGITTAL

    return orientation

if __name__ == "__main__":
    if len(sys.argv) < 4: 
        print("Error: three arguments are required. \n"
             +"       - The first is the input, the directory path of the dataset to filter,\n"
             +"         that directory should contain an index.json file.\n"
             +"       - The second is the filter: X_TRANSVERSE, Y_CORONAL or Z_SAGITTAL.\n"
             +"       - The third is the output file path where the filtered index will be written,\n"
             +"         only the studies and series with the orientation selected will be included.\n\n"
             +"Usage example: \n"
             +"   python3 %s datasets/e52faf1b-ecc2-4a96-957d-c8b4e34d607a Y_CORONAL persistent-home/e52faf1b-coronal-index.json\n" % sys.argv[0])
        sys.exit(1)

    if not sys.argv[2] in ["X_TRANSVERSE", "Y_CORONAL", "Z_SAGITTAL"]:
        print("Error: the second argument must be X_TRANSVERSE, Y_CORONAL or Z_SAGITTAL\n")
        sys.exit(1)

    dataset_dir_path = sys.argv[1]
    index_file_path = os.path.join(dataset_dir_path, "index.json")
    with open(index_file_path) as f:
        studies = json.load(f)

    filtered_studies = []
    filter = Orientation[sys.argv[2]]
    count = dict()
    for o in Orientation:
        count[o] = 0
    
    for study in studies:
        print(".", end='', flush=True)
        filtered_series = []
        for series in study["series"]:
            serie_dir_path = os.path.join(dataset_dir_path, study["path"], series["folderName"])
            files_list = os.listdir(serie_dir_path)
            for file in files_list:
                if file.lower().endswith(".dcm"):
                    #print(os.path.join(serie_dir_path, file))
                    dicom_file_path = os.path.join(serie_dir_path, file)
                    dcm = pydicom.dcmread(dicom_file_path)
                    if IMAGE_ORIENTATION_PATIENT_TAG in dcm:
                        orientation = extract_orientation(dcm[IMAGE_ORIENTATION_PATIENT_TAG].value)
                        count[orientation] += 1
                        if orientation == filter:
                            filtered_series.append(series)
                    break
        if len(filtered_series) > 0:
            study["series"] = filtered_series
            filtered_studies.append(study)

    print("\n# Input studies: " + str(len(studies)))
    print("##### Input series #####")
    for o in Orientation:
        print("# {:<14} {:>7}".format(o.name+':', count[o]))
    print("########################")
    print("# Output studies: " + str(len(filtered_studies)))
    print("# Output series: " + str(count[filter]))

    output_file_path = sys.argv[3]
    print("\nWriting filtered INDEX: %s\n" % output_file_path)
    with open(output_file_path , 'w') as output_stream:
        json.dump(filtered_studies, output_stream)
    
