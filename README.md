# License Plate Segmentation and OCR

This MATLAB code performs license plate segmentation and Optical Character Recognition (OCR) on a license plate image. The code applies various image processing techniques—including contrast enhancement, noise reduction, edge detection, morphological operations, and binary cleanup—to isolate the license plate region. Finally, OCR is used to extract text from the plate.

## Overview

The project consists of the following main steps:

### 1. **Image Preprocessing:**  
   - Load the image and convert it to grayscale.
     
![image](https://github.com/user-attachments/assets/f3d0df7e-157f-44fb-805e-da9472eaa39c)

### 2. **Contrast Enhancement and Noise Reduction:**  
   - Enhance the contrast using `imadjust` and reduce noise with a median filter.
     
![image](https://github.com/user-attachments/assets/22a8e334-4221-41f9-90e2-501f4a379708)

### 3. **Edge Detection and Morphological Operations:**  
   - Detect edges using the Canny method.
   - Apply morphological closing to fill gaps.
   - Fill holes to create solid regions.
     
![image](https://github.com/user-attachments/assets/5b62dbb0-6bc2-44f0-8b7c-c520061e924c)
![image](https://github.com/user-attachments/assets/4f60709b-c0f4-4bb0-84bd-d934da910263)
![image](https://github.com/user-attachments/assets/f7ec3559-94e6-443d-aaac-37402a76f8e1)

### 4. **Candidate Region Extraction:**  
   - Label connected components and compute region properties.
   - Select candidate regions based on area, aspect ratio, and extent.
   - Crop the candidate region assumed to be the license plate.
     
![image](https://github.com/user-attachments/assets/fbab8d8e-b195-4bb0-a871-a67c780e0fb3)
![image](https://github.com/user-attachments/assets/c1cf24c9-f716-4bbb-85d0-1c3cdfcf8dfc)

### 5. **Processing of License Plate:**  
   - Grayscale the segmented license plate.
     
![image](https://github.com/user-attachments/assets/ecb43586-9a58-4c03-a535-6963480c51ec)


### 6. **Binarization:**  
   - Convert the segmented license plate to a binary image using Otsu's method.

![image](https://github.com/user-attachments/assets/9f6ec3a4-2878-44e6-b54b-ca8d717afa29)


### 7. **Binary Image Cleanup:**  
   - Use a bridge operation to connect fragmented parts.
   - Invert the binary image, remove small objects with `bwareaopen`, and invert back.

![image](https://github.com/user-attachments/assets/4b0b21a6-7f6d-490c-99b0-f15ef87d41a8)


### 8. **OCR:**  
   - Apply OCR to the cleaned binary image and display the recognized text along with bounding boxes.

![image](https://github.com/user-attachments/assets/a28aa4b5-f158-4009-a396-6f533c975f99)

