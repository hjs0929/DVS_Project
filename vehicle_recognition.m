%% 1. Read and Preprocess the Image
I = imread('1.jpg'); % Insert number from 1-20 as jpg images.

% Convert to grayscale if the image is RGB
I_gray = rgb2gray(I);


%% 2. Enhance Contrast and Reduce Noise
I_adj = imadjust(I_gray);                % Adjust contrast to emphasise features
I_filtered = medfilt2(I_adj, [3 3]);     % Apply a median filter to reduce noise

%% 3. Edge Detection and Morphological Operations
BW_edges = edge(I_filtered, 'canny', [0.1, 0.25]); % Detect edges using Canny
se = strel('rectangle', [3 3]);                   % Structuring element for morphology
BW_closed = imclose(BW_edges, se);                % Fill gaps using morphological closing
BW_filled = imfill(BW_closed, 'holes');           % Fill holes to create solid regions

%% 4. Candidate Region Extraction for License Plate
cc = bwconncomp(BW_filled);                       % Label connected components
stats = regionprops(cc, 'Area', 'BoundingBox', 'Extent');

% Initialise an array to store candidate bounding boxes
plateCandidates = [];
for i = 1:length(stats)
    bb = stats(i).BoundingBox;
    aspectRatio = bb(3) / bb(4);
    if stats(i).Area > 1000 && aspectRatio > 2 && aspectRatio < 6 && stats(i).Extent > 0.5
        plateCandidates = [plateCandidates; bb];
    end
end

% Select the candidate with the largest area if available
areas = plateCandidates(:,3) .* plateCandidates(:,4);
[~, idx] = max(areas);
plateBB = plateCandidates(idx, :);
licensePlate = imcrop(I, plateBB);

%% 5. Visualise the Process
figure;

% Subplot 1: Original Image
subplot(3,3,1);
imshow(I);
title('Original Image');

% Subplot 2: Grayscale Image
subplot(3,3,2);
imshow(I_gray);
title('Grayscale Image');

% Subplot 3: Contrast Adjusted
subplot(3,3,3);
imshow(I_adj);
title('Contrast Adjusted');

% Subplot 4: Median Filtered
subplot(3,3,4);
imshow(I_filtered);
title('Median Filtered');

% Subplot 5: Edge Detection
subplot(3,3,5);
imshow(BW_edges);
title('Edge Detection');

% % Subplot 6: Morphological Closing
subplot(3,3,6);
imshow(BW_closed);
title('Morph. Closing');

% Subplot 7: Hole Filled Binary Image
subplot(3,3,7);
imshow(BW_filled);
title('Hole Filled');

% Subplot 8: Candidate Regions on Original Image
subplot(3,3,8);
imshow(I);
title('Candidate Regions');
hold on;
for i = 1:size(plateCandidates,1)
    rectangle('Position', plateCandidates(i,:), 'EdgeColor', 'red', 'LineWidth', 2);
end
hold off;

% Subplot 9: Segmented License Plate
subplot(3,3,9);
imshow(licensePlate);
title('Segmented License Plate');

%% 6. Grayscale the Segmented License Plate
Plate_gray = rgb2gray(licensePlate);


%% 7. Convert the Grayscaled License Plate to a Binary Image
Plate_binary = imbinarize(Plate_gray); % Convert to binary image (Otsu's method)


%% 8. Clean Up the Binary Image to Remove Small Objects
Plate_binary_clean = bwmorph(Plate_binary, 'bridge'); % Bridge fragmented components

BW_inv = ~Plate_binary_clean;              % Invert the image (black becomes white)
BW_inv_clean = bwareaopen(BW_inv, 4);        % Remove connected components smaller than 4 pixels
BW_clean = ~BW_inv_clean;                    % Invert back to original polarity

%% 9. OCR Text Recognition on the Cleaned Binary License Plate
if ~isempty(BW_clean)
    ocrResults = ocr(BW_clean);
    recognizedText = ocrResults.Text;
    fprintf('Recognised License Plate Text:\n%s\n', recognizedText);
else
    fprintf('No candidate license plate region detected for OCR.\n');
end

%% 10. Visualise the process
figure;

% Subplot 1: Grayscaled License Plate
subplot(2,2,1);
imshow(Plate_gray);
title('Grayscaled License Plate');

% Subplot 2: Binarized License Plate
subplot(2,2,2);
imshow(Plate_binary);
title('Binarised License Plate');

% Subplot 3: Cleaned Binary License Plate
subplot(2,2,3);
imshow(BW_clean);
title('Cleaned Binary License Plate');

% Subplot 4: OCR Result with Bounding Boxes
subplot(2,2,4);
imshow(BW_clean);
title('OCR Result');
hold on;
for k = 1:length(ocrResults.Words)
    bbox = ocrResults.WordBoundingBoxes(k, :);
    rectangle('Position', bbox, 'EdgeColor', 'yellow', 'LineWidth', 2);
    text(bbox(1), bbox(2)-10, ocrResults.Words{k}, 'Color', 'red', ...
        'FontSize', 12, 'FontWeight', 'bold');
end
hold off;

