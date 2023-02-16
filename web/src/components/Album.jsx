function Album(props) {
    // TO DO: Eventually send a list of albums
    const { img, size } = props.album;

    return (
        <div className="transition ease-in-out delay-150 hover:-translate-y-1 hover:scale-110">
            <img className="ring-2 ring-gray-500" src={img} width={size} height={size}/>
        </div>
    );
}

export default Album