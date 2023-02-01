function Album(props) {
    // TO DO: Eventually send a list of albums
    return (
        <div className="ring-2 ring-gray-500 transition ease-in-out delay-150 hover:-translate-y-1 hover:scale-110">
            <img src={props.album} width="200"/>
        </div>
    );
}

export default Album