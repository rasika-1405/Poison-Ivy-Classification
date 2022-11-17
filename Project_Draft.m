
function Project_Draft()

    apply_gaussian_filter = false;
    show_grayscale_versions = false;

    % read image

    im_rgb = im2double(imread("IMAGES/IMG_3127.JPG"));
    figure, imshow(im_rgb), title("Original image");

%     disp(size(im_in));

    im_resized = imresize(im_rgb, [600, 900]);

    % crop image

    rect = [182.5100  118.5100  573.9800  445.9800];
    im_cropped = imcrop(im_resized, rect);
    figure, imshow(im_cropped), title("cropped image");

    % sharpening the image

%     im_sharpened = imsharpen(im_cropped);
%     figure, subplot(1,2,1), imshow(im_sharpened), title("using imsharpen");
    im_sharpened = imsharpen(im_cropped,'Radius',2,'Amount',1);
    figure, imshow(im_sharpened), title("using imsharpen and parameters");

    % Applying gaussian filter to smoothen the image

    if (apply_gaussian_filter)
        fltr_gauss = fspecial('gaussian', [10 10], 0.75);
        im_smooth = imfilter( im_sharpened, fltr_gauss, 'same', 'repl');
        figure, imagesc(im_smooth);
        im_lab = rgb2lab(im_smooth);
        a_channel = im_lab(:,:,2);
        imagesc(a_channel);
    end

    % choosing the grayscale channel

    if (show_grayscale_versions)
        red = im_sharpened(:,:,1);
        green = im_sharpened(:,:,2);
        blue = im_sharpened(:,:,3);
    
        figure, subplot(1,3,1), imshow(red), title("Red channel");
        subplot(1,3,2), imshow(green), title("Green channel");
        subplot(1,3,3), imshow(blue), title("Blue channel");
    
        im_hsv = rgb2hsv(im_sharpened);
        hue = im_hsv(:,:,1);
        saturation = im_hsv(:,:,2);
        value = im_hsv(:,:,3);
    
        figure, subplot(1,3,1), imshow(hue), title("hue channel");
        subplot(1,3,2), imshow(saturation), title("saturation channel");
        subplot(1,3,3), imshow(value), title("value channel");
    
        im_lab = rgb2lab(im_sharpened);
        l_channel = im_lab(:,:,1);
        a_channel = im_lab(:,:,2);
        b_channel = im_lab(:,:,3);
        figure, imagesc(a_channel);
    
        figure, subplot(1,3,1), imagesc(l_channel), title("L channel");
        subplot(1,3,2), imagesc(a_channel), title("a* channel");
        subplot(1,3,3), imagesc(b_channel), title("b* channel");
    end

    im_lab = rgb2lab(im_sharpened);
    a_channel = im_lab(:,:,2);
    im_gray = a_channel;
    figure, imagesc(im_gray), title("a- grayscale image");

    % applying sobel filter to find edge magnitudes

    fltr_sobel_dIdy = [ -1 -2 -1 ; 
                         0  0  0 ; 
                        +1 +2 +1 ] /8;
    
    fltr_sobel_dIdx = fltr_sobel_dIdy.';
        
    dIdy = imfilter(im_gray, fltr_sobel_dIdy, 'same', 'repl');
    dIdx = imfilter(im_gray, fltr_sobel_dIdx, 'same', 'repl');
    dImag = sqrt( dIdy.^2  + dIdx.^2 );
    figure, imshow(dImag), title("dImag");

    % histogram analysis for egde magnitudes near the center leaves

    mag_min = min(dImag, [], 'all');
    mag_max = max(dImag, [], 'all');
    histogram_bin_edges = mag_min:0.001:mag_max;
%     histogram_bin_edges = 0:0.001:0.500;

    [freq,bins] = histcounts( dImag(:), histogram_bin_edges );
    tmp_sum = cumsum(freq);
    norm = tmp_sum ./ tmp_sum(end);
    index = find(norm>0.90,1,'first');
    cut_off_value = histogram_bin_edges(index);
%     disp(cut_off_value);

    im_strong_edges = dImag>cut_off_value;
    im_strong_edges = ~im_strong_edges;

    figure, imshow(im_strong_edges), title("after determining edge strength");

    % perform morphology

%     st = strel('square',3);
%     im_closed = imclose(im_strong_edges, st);
%     figure, imshow(im_closed), title("final shape of the leaves");

end