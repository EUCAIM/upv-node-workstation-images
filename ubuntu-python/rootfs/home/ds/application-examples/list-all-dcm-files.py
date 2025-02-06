import sys
import os
import json

if __name__ == "__main__":
    if len(sys.argv) < 2: 
        print("Error: al least one argument is required with the directory path of the dataset to list.\n"
             +"       That directory should contain an index.json file.\n"
             +"Usage example: python3 %s datasets/e52faf1b-ecc2-4a96-957d-c8b4e34d607a\n" % sys.argv[0])
        sys.exit(1)

    dataset_dir_path = sys.argv[1]
    index_file_path = os.path.join(dataset_dir_path, "index.json")
    with open(index_file_path) as f:
        studies = json.load(f)

    for study in studies:
        for series in study["series"]:
            serie_dir_path = os.path.join(dataset_dir_path, study["path"], series["folderName"])
            files_list = os.listdir(serie_dir_path)
            for file in files_list:
                if file.endswith(".dcm"):
                    print(os.path.join(serie_dir_path, file))


