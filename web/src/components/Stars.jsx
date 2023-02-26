function starSwtich(star) {
    switch (star) {
        case 1:
            return <div className="text-trillBlue text-md font-bold">½</div>;
        case 2:
            return <div className="text-trillBlue text-md font-bold">★</div>;
        case 3:
            return <div className="text-trillBlue text-md font-bold">★½</div>;
        case 4:
            return <div className="text-trillBlue text-md font-bold">★★</div>;
        case 5:
            return <div className="text-trillBlue text-md font-bold">★★½</div>;
        case 6:
            return <div className="text-trillBlue text-md font-bold">★★★</div>;
        case 7:
            return <div className="text-trillBlue text-md font-bold">★★★½</div>;
        case 8:
            return <div className="text-trillBlue text-md font-bold">★★★★</div>;
        case 9:
            return <div className="text-trillBlue text-md font-bold">★★★★½</div>;
        case 10:
            return <div className="text-trillBlue text-md font-bold">★★★★★</div>;
    }
}

function Stars(props) {
    return(
        <div>
            {starSwtich(props.rating)}
        </div>
    );
}

export default Stars

