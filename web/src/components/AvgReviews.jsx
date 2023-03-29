import Stars from "../components/Stars";

function AvgReviews(props) {
  const { average, numRatings } = props.reviewStats;
  const roundedAverage = Math.ceil(average);

  return (
    <div className="flex flex-col shadow-lg rounded-xl bg-[#383b59] text-gray-100 p-9 my-auto">
      <h2 className="text-2xl text-center text-violet-300 pb-5 font-bold">
        Average Rating
      </h2>
      {typeof average === "number" ? (
        <>
          <p className="text-5xl mx-auto font-bold">
            {roundedAverage > 0.5
              ? (roundedAverage / 2).toFixed(1)
              : roundedAverage}
          </p>

          <div className="flex text-3xl mx-auto pb-5">
            <Stars rating={roundedAverage} />
          </div>

          <p className="text-lg italic text-gray-300 mx-auto">
            {numRatings} global rating{numRatings === 1 ? "" : "s"}
          </p>
        </>
      ) : (
        <p className="text-xl mx-auto font-bold">Loading...</p>
      )}
    </div>
  );
}

export default AvgReviews;
