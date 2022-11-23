function build_classifier( )
%  This tests the use of the DecisionTree Classifiers to classify Poison Ivy and Non Poison Ivy leaves.
%
%  '22-Nov-2022'    Miloni Sangani  Rasika Sasturkar Harshil Patel
%

TEACHING    = true;

    leaf_classes                   = 'PN';

    initialize_the_feature_table    = true;

    for class_id = 1:length(leaf_classes)

        this_cls_letter = leaf_classes(class_id);
        if class_id == 1
            dir_name = "POISON/*.JPG";
            input_dir = 'POISON';
        else
            dir_name = "NON_POISON/*.JPG";
            input_dir = 'NON_POISON';
        end
%         dir_name = sprintf("POISON/*%s", image_suffix);
        training_files = dir(dir_name);

        for idx = 1 : length( training_files )

%             fn_in       = training_files(idx).name;

            fn_in       = sprintf('%s%c%s', input_dir, filesep(), training_files(idx).name );
            fprintf('%s\n', fn_in );
%             fn_in = convertCharsToStrings(fn_in);
%             disp(fn_in);
%             disp(class(fn_in));

            im_in     = imread( fn_in );

            %
            %  DO NOISE CLEANING ON THE IMAGE.
            %
            %  NOTE: Must be done exactly the same way as when BUILDING
            %  the classifier as when USING the classifier.
            %
            %
            %  CHANGE ME:  YOU NEED TO WRITE THIS ROUTINE...
%             disp("HI");
            im_cleaned  = clean_image( im_in );

            %
            %  EXTRACT FEATURES FROM THE IMAGE.
            %
            %  AGAIN: Must be done exactly the same way as when BUILDING
            %  the classifier as when USING the classifier.
            %
            %  The feature extraction routine encapsulates the process of 
            %  finding small parts, and collecting features on them.
            %
            %  I don't even know what the features are.
            %
            %  CHANGE ME:  YOU NEED TO WRITE THIS ROUTINE...
            feats       = get_features( im_cleaned );
            n_new       = size( feats, 1 );

            if ( initialize_the_feature_table == true )
                initialize_the_feature_table                     = false;

                collected_feats                     = feats;
                class_list(1:n_new)                 = class_id;
            else
                collected_feats(end+1:end+n_new,:)  = feats;
                class_list(end+1:end+n_new)         = class_id;
            end
            
            if ( TEACHING == true )
                imagesc( im_cleaned );
                colormap( copper );
                title( ['Leaves of Class  ', this_cls_letter, '  '], ...
                       'FontSize', 32 );
                axis image;
                drawnow;
                print_mat( feats, 1, 'Features', 2 );
            end
        end
    end

    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %
    %   Now, build a classifier, based on the collected data:
    %
    %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tree_classifier = fitctree( collected_feats, class_list );
    
    %
    %  Test using the tree -- Create a Confusion Matrix:
    %
    %  setup and fill in a confusion_matrix
    %
    con_mat = zeros(length(leaf_classes));
    for instance_id = 1 : size( collected_feats, 1 )
        true_cls                        = class_list( instance_id );
        pred_cls                        = tree_classifier.predict( collected_feats(instance_id,:) );
        con_mat( pred_cls, true_cls )   = con_mat( pred_cls, true_cls ) + 1;
    end

    print_mat( con_mat, 1, 'confusion_matrix_on_training_data', 0 );
    fprintf('\n\n');

    save tree_classifier_634.mat tree_classifier;
        
end

