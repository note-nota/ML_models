import numpy as np
from tensorflow.keras.preprocessing.image import ImageDataGenerator


class ArcFaceImageGenerator(ImageDataGenerator):
    def __init__(self, **kwargs):
        super(ArcFaceImageGenerator, self).__init__(**kwargs)
    
    def flow_from_directory(self, directory, target_size, batch_size, class_mode):
        batches = super().flow_from_directory(directory, 
            target_size = target_size,
            batch_size = batch_size,
            class_mode = class_mode
        )
        while True:
            inputs, outputs = next(batches)
            yield [inputs, outputs], outputs


def preprocessing(x):
    if x.shape[0] > x.shape[1]:
        x = x.transpose(1, 0, 2)[::-1, ::, :]
    
    return (x - 127.5) / 128

def generate_images(directory, batch_size, train=True):
    if train:
        datagen= ArcFaceImageGenerator(
            preprocessing_function=preprocessing,
            shear_range=0.1,
            zoom_range=0.05,
            rotation_range=10,
            fill_mode="constant",
            width_shift_range=0.04,
            height_shift_range=0.04
        )
    else:
        datagen = ArcFaceImageGenerator(preprocessing=preprocessing)


    generator = datagen.flow_from_directory(
        directory,
        target_size=(100, 100),
        batch_size=batch_size,
        class_mode="categorical"
    )

    return generator

if __name__ == "__main__":
    pass