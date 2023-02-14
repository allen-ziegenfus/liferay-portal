import React, { ReactNode, createContext, useContext, useReducer } from "react";
import { UploadedFile } from "../components/FileList/FileList";

import { appReducer, TAction } from "./reducer";

type Categories = {
  label: string;
  value: string;
  checked: boolean;
};

export interface InitialStateProps {
  appBuild: string;
  appCategories: Categories[];
  appDescription: string;
  appLogo: UploadedFile;
  appName: string;
  LXC_Compatibility: string;
  priceModel: string;
}

const initialState = {
  appBuild: "upload",
  LXC_Compatibility: "yes",
  priceModel: "paid",
} as InitialStateProps;

interface AppContextProps extends Array<InitialStateProps | Function> {
  0: typeof initialState;
  1: React.Dispatch<
    React.ReducerAction<React.Reducer<InitialStateProps, TAction>>
  >;
}

const AppContext = createContext({} as AppContextProps);

interface AppContextProviderProps {
  children: ReactNode;
}

export function AppContextProvider({ children }: AppContextProviderProps) {
  const [state, dispatch] = useReducer<
    React.Reducer<InitialStateProps, TAction>
  >(appReducer, { ...initialState });

  return (
    <AppContext.Provider value={[state, dispatch]}>
      {children}
    </AppContext.Provider>
  );
}

export function useAppContext() {
  return useContext(AppContext);
}
