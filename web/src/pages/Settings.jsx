function Settings() {
    return (
        <div>
        <div className="md:grid md:grid-cols-3 md:gap-6 m-24">
          <div className="md:col-span-1">
            <div className="px-4 sm:px-0">
              <h3 className="text-3xl font-bold leading-6 text-white">Trill Profile</h3>
              <p className="mt-5 text-lg text-gray-200">
                Showcase your personality by customizing your profile page.
              </p>
            </div>
          </div>
          <div className="mt-5 md:col-span-2 md:mt-0">
            <form action="#" method="POST">
              <div className="shadow sm:overflow-hidden sm:rounded-md">
                <div className="space-y-6 bg-gray-600 px-4 py-5 sm:p-6">
                
                  <div className="grid grid-cols-3 gap-6">

                    {/* First Name Input */}
                    <div className="col-span-3 sm:col-span-2">
                      <label htmlFor="firstName" className="block text-sm font-bold text-gray-100">
                        First Name
                      </label>
                      <div className="mt-1 flex rounded-md shadow-sm">
                        <input
                          type="text"
                          name="firstName"
                          id="firstName"
                          className="block w-full flex-1 rounded-lg border-gray-300 focus:border-trillBlue focus:ring-trillBlue sm:text-sm"
                          placeholder="Taylor"
                        />
                      </div>
                    </div>

                    {/* Last Name Input */}
                    <div className="col-span-3 sm:col-span-2">
                      <label htmlFor="lastName" className="block text-sm font-bold text-gray-100">
                        Last Name
                      </label>
                      <div className="mt-1 flex rounded-md shadow-sm">
                        <input
                          type="text"
                          name="lastName"
                          id="lastName"
                          className="block w-full flex-1 rounded-lg border-gray-300 focus:border-trillBlue focus:ring-trillBlue sm:text-sm"
                          placeholder="Swift"
                        />
                      </div>
                    </div>

                  </div>

                  <div>
                    <label htmlFor="bio" className="block text-sm font-bold text-gray-100">
                      Bio
                    </label>
                    <div className="mt-1">
                      <textarea
                        id="bio"
                        name="bio"
                        rows={3}
                        className="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-trillBlue focus:ring-trillBlue sm:text-sm"
                        placeholder="My life through music"
                        defaultValue={''}
                      />
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm font-bold text-gray-100">Photo</label>
                    <div className="mt-1 flex items-center">
                      <span className="inline-block h-12 w-12 overflow-hidden rounded-full bg-gray-100">
                        <svg className="h-full w-full text-gray-300" fill="currentColor" viewBox="0 0 24 24">
                          <path d="M24 20.993V24H0v-2.996A14.977 14.977 0 0112.004 15c4.904 0 9.26 2.354 11.996 5.993zM16.002 8.999a4 4 0 11-8 0 4 4 0 018 0z" />
                        </svg>
                      </span>
                      <button
                        type="button"
                        className="ml-5 rounded-md border border-gray-300 bg-white py-2 px-3 text-sm font-bold leading-4 text-gray-700 shadow-sm hover:bg-gray-50 focus:ring-2 focus:ring-trillBlue"
                      >
                        Change
                      </button>
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm font-bold text-gray-100">Cover photo</label>
                    <div className="mt-1 flex justify-center rounded-md border-2 border-dashed border-gray-300 px-6 pt-5 pb-6">
                      <div className="space-y-1 text-center">
                        <svg
                          className="mx-auto h-12 w-12 text-gray-400"
                          stroke="currentColor"
                          fill="none"
                          viewBox="0 0 48 48"
                          aria-hidden="true"
                        >
                          <path
                            d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02"
                            strokeWidth={2}
                            strokeLinecap="round"
                            strokeLinejoin="round"
                          />
                        </svg>
                        <div className="flex text-sm text-gray-600">
                          <label
                            htmlFor="file-upload"
                            className="relative cursor-pointer rounded-md bg-gray-600 font-bold text-indigo-200 focus-within:outline-none focus-within:ring-2 focus-within:ring-indigo-200 focus-within:ring-offset-2 hover:text-indigo-300 mx-auto"
                          >
                            <span>Upload a file</span>
                            <input id="file-upload" name="file-upload" type="file" className="sr-only" />
                          </label>
                        </div>
                        <p className="text-xs text-gray-200">PNG, JPG, GIF up to 10MB</p>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="bg-gray-600 px-4 py-3 text-right sm:px-6">
                  <button
                    type="submit"
                    className="inline-flex justify-center rounded-md border border-transparent bg-trillBlue py-2 px-4 text-sm font-bold text-gray-900 shadow-sm hover:text-gray-200 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                  >
                    Save
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    );
}

export default Settings;