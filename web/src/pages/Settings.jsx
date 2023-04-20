import { useQuery, useMutation } from "@tanstack/react-query";
import { useState } from "react"
import axios from "axios";

// Components
import Toast from "../components/Toast";
import Avatar from "../components/Avatar";

function Settings() {
    // Toast 
    const [isSuccess, setIsSuccess] = useState(false);
    const [dismissed, setDismissed] = useState(true);
    const [profPic, setProfPic] = useState(null);
    const { data: userData } = useQuery(['users'], {onSuccess: (data) => {setProfPic(data.profile_picture)}});
  
    const update = useMutation(upUser => {
      return axios.put('https://api.trytrill.com/main/users', upUser, { headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization' : `Bearer ${sessionStorage.getItem('access_token')}`}})
    }, {
      onSettled: () => {setTimeout(() => {setDismissed(true)}, 7000);},
      onError: () => {setIsSuccess(false)}
    });

    const updateUser = (event) => {
      event.preventDefault();
      const formData = new FormData(event.target);
      if (formData.get('file-upload').size > 8388608) {
        setIsSuccess(false);
      } else {
        const requestBody = new FormData();
        requestBody.append('nickname', formData.get('name'));
        requestBody.append('bio', formData.get('bio'));
        requestBody.append('profilePicture', formData.get('file-upload'));

        update.mutate(requestBody);
        setIsSuccess(true);
      }
      setDismissed(false);
    };

    const handleDismiss = () => {
      setDismissed(true);
    };

    const handleUpload = (event) => {
      setProfPic(URL.createObjectURL(event.target.files[0]));
    }

    return (
        <div>
          <div className="md:grid md:grid-cols-3 md:gap-6 m-24 max-w-5xl mx-auto">
            <div className="md:col-span-1">
              <div className="px-4 sm:px-0">
                <h3 className="text-3xl font-bold leading-6 text-white">Trill Profile 🎵</h3>
                <p className="mt-5 text-lg text-gray-200 pb-10">
                  Showcase your personality by customizing your profile page.
                </p>
              </div>
              {!dismissed && (
                <Toast toast={{
                  message: isSuccess ? "Saved user profile" : "Could not save user profile", 
                  type: isSuccess ? "success" : "error", 
                  onDismiss: handleDismiss}} 
                />
              )}
            </div>

          <div className="mt-5 md:col-span-2 md:mt-0">
              <form onSubmit={updateUser}>
                <div className="shadow sm:overflow-hidden sm:rounded-md">
                  <div className="space-y-6 bg-gray-700 px-4 py-5 sm:p-6">
                    <div className="grid grid-cols-3 gap-6">

                      {/* Name Input */}
                      <div className="col-span-3 sm:col-span-2 pb-3">
                        <label htmlFor="name" className="block text-sm font-bold text-gray-100">
                          Name
                        </label>
                        <div className="mt-1 flex rounded-md shadow-sm">
                          <input
                            type="text"
                            name="name"
                            id="name"
                            className="text-gray-400 block w-full flex-1 rounded-lg border-gray-300 focus:border-trillBlue focus:ring-trillBlue sm:text-sm"
                            placeholder="John Doe"
                            defaultValue={userData?.nickname}
                          />
                        </div>
                      </div>
                    </div>

                    <div className="pb-3">
                      <label htmlFor="bio" className="block text-sm font-bold text-gray-100">
                        Bio
                      </label>
                      <div className="mt-1">
                        <textarea
                          id="bio"
                          name="bio"
                          rows={3}
                          className="text-gray-400 mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-trillBlue focus:ring-trillBlue sm:text-sm"
                          placeholder="My life, through music."
                          defaultValue={userData?.bio}
                        />
                      </div>
                    </div>

                    <div className="pb-10">
                      <label className="block text-sm font-bold text-gray-100">Profile Picture</label>
                      <p className="text-sm text-gray-400">Maximum upload file size: 8 MB</p>
                      <div className="mt-1 flex items-center">
                        <span className="inline-block h-12 w-12 overflow-hidden rounded-full bg-gray-100 ring-2 ring-trillBlue">
                          {/* Commented this out in case you want to use it later Ashley */}
                          {/* <svg className="h-full w-full text-gray-300" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M24 20.993V24H0v-2.996A14.977 14.977 0 0112.004 15c4.904 0 9.26 2.354 11.996 5.993zM16.002 8.999a4 4 0 11-8 0 4 4 0 018 0z" />
                          </svg> */}
                          <Avatar user={{ profile_picture: profPic, username: userData?.username, size: "12", linkDisabled: true }} />
                        </span>
                        <div className="ml-5 rounded-md border border-gray-300 bg-white py-2 px-3 text-sm font-bold leading-4 text-gray-700 shadow-sm hover:bg-gray-50 focus:ring-2 focus:ring-trillBlue">
                            <label
                              htmlFor="file-upload"
                              className="relative cursor-pointer rounded-md font-bold text-gray-900 focus-within:outline-none  hover:text-blue-500 mx-auto"
                            >
                              <span>Upload a file</span>
                              <input id="file-upload" name="file-upload" type="file" className="sr-only" onChange={handleUpload}/>
                            </label>
                          </div>
                      </div>
                    </div>
                  </div>

                  <div className="bg-gray-600 px-4 py-3 text-right sm:px-6">
                    <button
                      type="submit"
                      className="inline-flex justify-center rounded-md border border-transparent bg-trillBlue py-2 px-4 text-sm font-bold text-gray-700 shadow-sm hover:text-white"
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