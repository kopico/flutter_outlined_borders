
## Features

This package includes some shape borders that allow you to create immediately within a container widget.

Some implemented borders are:
-   Droplet shape borders
-   Oval shape borders
-   Round base rectangle borders

## Getting started

To use the borders, simply import the package via "flutter pub add flutter_outlined_borders", and it will be ready to be use
wherever a property requires a "Shape Border property".


## Usage

For example,

build(BuildContext context){
    return Container(
        width: 100,
        height: 50,
        decoration: ShapeDecoration(
            shape: RoundBaseRectangleBorder(
                side: BorderSide(width: 1.0, color: Colors.black)
            ),
            color: Colors.amber
        )
    );
}

## Additional information

Most of the borders requires size. If no appropriate size is provided, the container using the shape
will not render even if the container is not using the shape borders from this package. This is even
if the system does not show any debug error for not providing a size.
