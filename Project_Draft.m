
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
    figure, imshow(im_cropped);

    % sharpening the image
%     im_sharpened = imsharpen(im_cropped);
%     figure, subplot(1,2,1), imshow(im_sharpened), title("using imsharpen");
%     im_sharpened = imsharpen(im_cropped,'Radius',2,'Amount',1);
%     subplot(1,2,2), imshow(im_sharpened), title("using imsharpen and parameters");

    % Applying gaussian filter to smoothen the image
    if (apply_gaussian_filter)
        my_filter = fspecial('gaussian', [10 10], 0.75);
        im_smooth = imfilter( im_cropped, my_filter, 'same', 'repl');
        figure, imagesc(im_smooth);
        im_lab = rgb2lab(im_smooth);
        a_channel = im_lab(:,:,2);
        imagesc(a_channel);
    end

    % choosing the grayscale channel

    if (show_grayscale_versions)
        red = im_cropped(:,:,1);
        green = im_cropped(:,:,2);
        blue = im_cropped(:,:,3);
    
        figure, subplot(1,3,1), imshow(red), title("Red channel");
        subplot(1,3,2), imshow(green), title("Green channel");
        subplot(1,3,3), imshow(blue), title("Blue channel");
    
        im_hsv = rgb2hsv(im_cropped);
        hue = im_hsv(:,:,1);
        saturation = im_hsv(:,:,2);
        value = im_hsv(:,:,3);
    
        figure, subplot(1,3,1), imshow(hue), title("hue channel");
        subplot(1,3,2), imshow(saturation), title("saturation channel");
        subplot(1,3,3), imshow(value), title("value channel");
    
        im_lab = rgb2lab(im_cropped);
        l_channel = im_lab(:,:,1);
        a_channel = im_lab(:,:,2);
        b_channel = im_lab(:,:,3);
        figure, imagesc(a_channel);
    
        figure, subplot(1,3,1), imagesc(l_channel), title("L channel");
        subplot(1,3,2), imagesc(a_channel), title("a* channel");
        subplot(1,3,3), imagesc(b_channel), title("b* channel");
    end

    im_lab = rgb2lab(im_cropped);
    a_channel = im_lab(:,:,2);
    im_gray = a_channel;
    figure, imagesc(im_gray);

    % sharpen the image
    im_sharpened = imsharpen(im_gray,'Radius',2,'Amount',1);
    figure, subplot(1,2,1), imagesc(im_sharpened), title("using imsharpen and parameters");

    im_sharpened = imsharpen(im_gray);
    subplot(1,2,2), imagesc(im_sharpened), title("using imsharpen");


end